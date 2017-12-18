class Event < ActiveRecord::Base
    validates :name, 
        length: { in: 4..35, message: "Event names must be between 4 and 35 characters." },
        format: { with: /\A[a-zA-Z0-9\s[[:punct:]]]+\z/, message: "Event names may only include letters, numbers, and punctuation." }
    validates :location,
        length: { in: 1..25, message: "Location must be between 1 and 25 characters." },
        format: { with: /\A[a-zA-Z.\-'\s]+\z/, message: "Locations may only contain letters, spaces, periods, dashes, and apostrophes." }
    validates :date, presence: { message: "You must provide a date for your event." }
    validates :time, presence: { message: "You must provide a time for your event." }
    validates :description, length: { maximum: 500, message: "Event description may not exceed 500 characters." }
    validate :future_dated
    validate :check_state

    belongs_to :user, required: true
    has_many :attendee, dependent: :destroy
    has_many :attendees, through: :attendee, source: :user
    has_many :comments, dependent: :destroy

    before_save :set_cases

    private
    def future_dated
        errors.add(:date, "You may not add events that have already occured.") if date.present? && date < Date.current
        errors.add(:time, "You may not add events that have already occured.") if date.present? && time.present? && date == Date.current && time < Time.now
    end

    def check_state
        states = %w(AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY)
        if self.state.present?
            errors.add(:state, "You making up fake states now huh?") unless states.include? self.state
        end
    end

    def set_cases
        self.state.upcase!
        self.location = self.location.titleize
        self.name = self.name.titleize
    end

end
