class ScrumblerIssueCustomField < IssueCustomField
  unloadable
  
  validate :scrumbler_points_field
    class << self

    ScrumPointsName = "Scrum Points"
    @@points = nil
    def customized_class; Issue; end
    
    def points
      @@points ||= first(:conditions => {:name => ScrumPointsName}) ||
      create( :name => ScrumPointsName,
        :field_format => "list",
        :possible_values => %w(? 0 0.5 1 2 3 5 8 13 20 40 100),
        :is_required => true,
        :is_filter => true,
        :default_value => "?",
        :trackers => Tracker.all)
    end

  end
  
  def type; "IssueCustomField" ;end

  def find_value_by_issue(issue)
    CustomValue.first(:conditions => {
      :customized_id => issue.id,
      :custom_field_id => self.id,
      :customized_type => issue.class.to_s
    })
  end

  def find_all_values
    CustomValue.all(:conditions => {
      :custom_field_id => self.id
    })
  end


  
  private
  def scrumbler_points_field
    if !new_record? && self == self.class.points
      errors.add(:possible_values, :invalid) if possible_values.find {|v| !(v =~ /^((\d)+[.]?(\d)*|[?])/)}
    end
  end

end