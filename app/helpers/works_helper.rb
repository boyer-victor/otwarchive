module WorksHelper

  # For use with chapter virtual attributes
  def fields_for_associated(creation, associated, &block)
    fields_for(name_attributes(creation, associated.class.to_s.downcase), associated, &block)
  end

  def name_attributes(creation, attribute_type)
   creation + "[" + attribute_type + "_attributes]"
  end
  
  # List of date, chapter and length info for the work show page
  def work_meta_list(work)
    # if we're previewing, grab the unsaved date, else take the saved first chapter date
    published_date = (@chapter && params[:preview_button]) ? @chapter.published_at : work.first_chapter.published_at
    list = [['Published:', localize(published_date)], ['Words:', work.word_count], ['Chapters:', work.chapter_total_display]]
    if work.chaptered? && work.revised_at
      prefix = work.is_wip ? "Updated:" : "Completed:"
      list.insert(1, [prefix, localize(work.revised_at.to_date)])
    end
    '<dl>' + list.map {|l| '<dt>' + l.first + '</dt><dd>' + l.last.to_s + '</dd>'}.to_s + '</dl>'
  end
  
  def work_top_links_list(work)
    bookmark_link = logged_in? ? '<li>' + bookmark_link(work) + '</li>' : ''			
    comments_link = '<li>' + link_to("Comment(s)", work_path(work, :show_comments => true, :anchor => 'comments')) + '</li>'  
    "<ul>" + bookmark_link + (comments_link ||= '') + "</ul>"    
  end
  
  # work.tags doesn't include unsaved tags on preview
  def collect_work_tags(work, preview_mode=nil)
    if preview_mode
      (work.ratings + work.categories + work.warnings + work.fandoms + work.characters + work.pairings + work.freeforms + work.tags).flatten.uniq
    else
      work.tags
    end  
  end

  
  # modified from mislav-will_paginate-2.3.2/lib/will_paginate/view_helpers.rb
  def search_header(collection, search_query)
    if search_query.blank?
      search_query = " found"
    else
      search_query = html_escape search_query
      search_query = " found for '" + search_query + "'"
    end
    if collection.total_pages < 2
      case collection.size
      when 0; "0 Works" + search_query
      when 1; "1 Work" + search_query
      else; collection.total_entries.to_s + " Works" + search_query
      end
    else
      %{ %d - %d of %d }% [
        collection.offset + 1,
        collection.offset + collection.length,
        collection.total_entries
      ] + "Works" + search_query
    end
  end
  
  # Making absolutely sure that the tags and selected tags have the same capitalization so it doesn't throw the form off
  def warnings_for_tag_form
    [ArchiveConfig.WARNING_DEFAULT_TAG_NAME, ArchiveConfig.WARNING_SOME_TAG_NAME, ArchiveConfig.WARNING_NONE_TAG_NAME, ArchiveConfig.WARNING_VIOLENCE_TAG_NAME, ArchiveConfig.WARNING_DEATH_TAG_NAME, ArchiveConfig.WARNING_NONCON_TAG_NAME, ArchiveConfig.WARNING_CHAN_TAG_NAME].map(&:titleize)
  end

  # select the default warnings if this is a new work
  def warning_selected(work)
    work.nil? || work.warning_strings.empty? ? ArchiveConfig.WARNING_DEFAULT_TAG_NAME : work.warning_strings.map(&:titleize)
  end
  
  # select default rating if this is a new work
  def rating_selected(work)
    work.nil? || work.rating_string.empty? ? ArchiveConfig.RATING_DEFAULT_TAG_NAME : work.rating_string
  end
  
  def category_selected(work)
    work.nil? || work.category_string.empty? ? ArchiveConfig.CATEGORY_DEFAULT_TAG_NAME : work.category_string
  end

  def get_title_string(tags, category_name = "")
    if tags && tags.size > 0
      tags.collect(&:name).join(", ")
    else
      category_name.blank? ? "" : "No" + " " + category_name
    end
  end

  def get_symbols_for(work, symbols_only = false)
    unless work.class == ExternalWork
      warnings = work.tags.select{|tag| tag.type == "Warning"}
      warning_class = get_warnings_class(warnings)
      warning_string = get_title_string(warnings)
    else
      warning_class = "external-work"
      warning_string = "External Work"
    end
    
    ratings = work.tags.select{|tag| tag.type == "Rating"}
    rating = ratings.blank? ? nil : ratings.first
    rating_class = get_ratings_class(rating)
    rating_string = get_title_string(ratings, "rating")
    
    categories = work.tags.select{|tag| tag.type == "Category"}
    category = categories.blank? ? nil : categories.first
    category_class = get_category_class(category)
    category_string = get_title_string(categories, "category")

    iswip_class = get_complete_class(work)
    if work.class == Work
      iswip_string = work.is_wip ? "Work in Progress" : "Complete Work"
    else
      iswip_string = "External Work"
    end

    symbol_block = ""
    symbol_block << "<ul class=\"required-tags\">\n" if not symbols_only
    %w(rating category warning iswip).each do |w|
      css_class = eval("#{w}_class")
      title_string = eval("#{w}_string")
      symbol_block << "<li class=\"#{css_class}\">"
      symbol_block << link_to_help('symbols-key', link = image_tag( "#{css_class}.png", :alt => title_string, :title => title_string))
      symbol_block << "</li>\n"
    end
    symbol_block << "</ul>\n" if not symbols_only 
    return symbol_block
  end

  def get_warnings_class(warning_tags)
    return "warning-yes" unless warning_tags
    none = true
    warning_tags.map(&:name).each do |name|
      none = false if name != ArchiveConfig.WARNING_NONE_TAG_NAME
    end
    return "warning-no" if none
    "warning-yes"
  end

  def get_ratings_class(rating_tag)
    return "rating-notrate" unless rating_tag
    case rating_tag.name
    when ArchiveConfig.RATING_EXPLICIT_TAG_NAME
      "rating-explicit"
    when ArchiveConfig.RATING_MATURE_TAG_NAME
      "rating-mature"
    when ArchiveConfig.RATING_TEEN_TAG_NAME
      "rating-teen"
    when ArchiveConfig.RATING_GENERAL_TAG_NAME
      "rating-general-audience"
    else
      "rating-notrated"
    end
  end

  def get_category_class(category_tag)
    return "category-none" unless category_tag
    case category_tag.name
    when ArchiveConfig.CATEGORY_GEN_TAG_NAME
      "category-gen"
    when ArchiveConfig.CATEGORY_SLASH_TAG_NAME
      "category-slash"
    when ArchiveConfig.CATEGORY_HET_TAG_NAME
      "category-het"
    when ArchiveConfig.CATEGORY_FEMSLASH_TAG_NAME
      "category-femslash"
    when ArchiveConfig.CATEGORY_MULTI_TAG_NAME
      "category-multi"
    when ArchiveConfig.CATEGORY_OTHER_TAG_NAME
      "category-other"
    else
      "category-none"
    end
  end

  def get_complete_class(work)
    return "category-none" if work.class == ExternalWork
    if work.is_wip
      "complete-no"
    else
      "complete-yes"
    end
  end
  
  # Return a string to determine whether the published at field should show on the work form
  def check_backdate_box(work, chapter)
    if work.backdate || (chapter.created_at && chapter.created_at.to_date != chapter.published_at)
		  'checked="checked"'
    else
      ''
    end
  end

  # Use time_ago_in_words if less than a month ago, otherwise display date
  def set_format_for_date(datetime)
    return "" unless datetime.is_a? Time
    if datetime > 30.days.ago
      time_ago_in_words(datetime)
    else
      datetime.to_date.to_formatted_s(:rfc822)
    end
  end

end
