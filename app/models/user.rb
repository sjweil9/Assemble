class User < ActiveRecord::Base
    has_secure_password(validations: false)

    validates_confirmation_of :password, if: :password_present
    validates_presence_of :password, on: :create
    
    validates :first, :last,
        length: { in: 2..20, message: "Names must be between 2 and 20 characters." },
        format: { with: /\A[a-zA-Z.\s]+\z/, message: "Names may only contain letters or periods." }
    validates :email,
        length: { in: 5..75, message: "Email must be between 5 and 75 characters." },
        format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i, message: "Email format invalid." },
        uniqueness: { message: "Email already registered." }
    validates :location,
        length: { in: 1..25, message: "Location must be between 1 and 25 characters." },
        format: { with: /\A[a-zA-Z.\-'\s]+\z/, message: "Locations may only contain letters, spaces, periods, dashes, and apostrophes." }
    validates :password, format: { 
        with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%&?]).{8,72}\z/, 
        message: "Password format invalid." 
    },
        length: { minimum: 8, message: "Password must be at least 8 characters." }, if: :password_present

    validate :check_state

    before_create :set_defaults
    before_save :set_cases

    has_many :events, dependent: :destroy
    has_many :attendee, dependent: :destroy
    has_many :events_attended, through: :attendee, source: :event
    has_many :comments, dependent: :destroy

    def activate_email
        self.email_confirmed = true
        self.confirm_token = nil
        save!(:validate => false)
    end

    def unlock_account
        self.account_locked = false
        self.login_attempts = 0
        self.last_attempt = DateTime.now
        self.unlock_token = nil
        save!(:validate => false)
    end

    private
    def set_defaults
        self.email_confirmed = false
        self.account_locked = false
        self.login_attempts = 0
        self.last_attempt = DateTime.now
        self.unlock_token = nil
        self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end

    def check_state
        states = %w(AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY)
        if self.state.present?
            errors.add(:state, "You making up fake states now huh?") unless states.include? self.state.upcase
        end
    end

    def set_cases
        self.email.downcase!
        self.state.upcase!
        self.location = self.location.titleize
        self.first = self.first.titleize
        self.last = self.last.titleize
    end

    def password_present
        self.password.present?
    end

end
