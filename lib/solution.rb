require "pry"

def correct_half_circle(difference_angle)
    if difference_angle > 180
        return (360 - difference_angle)
    end
    difference_angle
end

def iterate_next_floats(number, iterations)
    iterations.times do ||
        # binding.pry
        number = number.next_float
    end
    number
end

def iterate_prev_floats(number, iterations)
    iterations.times do ||
        number = number.prev_float
    end
    # binding.pry
    number
end

def adjust_ugly_float_crap(number)
    # attempt to fix weird floating point issues like:
    #
    # 1) #clock_angle(time) returns the correct angle between the clock hands representing 3:15
    #      Failure/Error: expect(clock_angle("3:15")).to eq(7.5)
    #     
    #        expected: 7.5
    #             got: 7.500000000000004
    #     
    #        (compared using ==)
    #      # ./spec/angle_spec.rb:15:in `block (2 levels) in <top (required)>'
    #
    # and:
    #  2) #clock_angle(time) returns the correct angle between the clock hands representing 3:15
    # Failure/Error: expect(clock_angle("8:30")).to eq(75)
        
    # expected: 75
    #      got: 74.99999999999996

    # (compared using ==)
    # # ./spec/angle_spec.rb:19:in `block (2 levels) in <top (required)>'
    new_number = number
    6.times do |x|
        if (iterate_next_floats(new_number, x) % 1 ) == 0
            return iterate_next_floats(new_number, x)
        end
        if (iterate_next_floats(new_number, x) % 0.1) == 0
            return iterate_next_floats(new_number, x)
        end
    end

    new_number = number
    10.times do |x|
        # binding.pry
        if (iterate_prev_floats(new_number, x) % 1) == 0
            # binding.pry
            return iterate_prev_floats(new_number, x)
        end
        prev_f = iterate_prev_floats(new_number, x)
        if (( prev_f % 0.1) > 0.09) && ((prev_f % 0.1) < 0.11)
            # binding.pry
            return prev_f
        end
        # number = prev_f
    end
    number
end

def clock_angle(time)
    split_h_m = time.split(":")
    hours_s = split_h_m[0]
    minutes_s = split_h_m[1]
    hours = hours_s.to_f
    minutes = minutes_s.to_f
    hours_radians_uncorrected = (hours/12) * (2 * Math::PI)
    minutes_radians = (minutes/60) * (2 * Math::PI)
    hours_radians = hours_radians_uncorrected + (minutes_radians / 12)


    difference_radians = hours_radians - minutes_radians

    difference_angle = ((difference_radians / (2 * Math::PI)) * 360)
    difference_angle_corrected = correct_half_circle(difference_angle)
    difference_angle_float_corrected = adjust_ugly_float_crap(difference_angle_corrected)
    # if time == "3:15"
    #     binding.pry
    # end
    difference_angle_float_corrected
end
