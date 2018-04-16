RSpec.describe Sundial::TimeDifference do
  let(:business_hours) {
    {
      mon: ['09:00', '17:00'],
      tue: ['09:00', '17:00'],
      wed: ['09:00', '17:00'],
      thu: ['09:00', '17:00'],
      fri: ['09:00', '17:00']
    }
  }
  let(:schedule) { Sundial::Schedule.new(business_hours) }

  subject(:time_difference) { described_class.new(schedule) }

  describe '#elapsed' do
    context 'when the start time is on a day defined in the schedule' do
      context 'when the start time is before business hours' do
        let(:from) { Time.new(2018, 02, 14, 6) } # 14 February 2018 is a Wednesday

        context 'when the end time is on the same day' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 14, 8) }

            it 'returns a zero duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(0)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 14, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(1 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 14, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(8 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is on the following day and defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 15, 8) } # 15 February 2018 is a Thursday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(8 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 15, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(9 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 15, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(16 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is several days further and not defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 17, 8) } # 17 February 2018 is a Saturday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(24 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 17, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(24 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 17, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(24 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is several days further and defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 21, 8) } # 21 February 2018 is a Wednesday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(40 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 21, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(41 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 21, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(48 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end
      end

      context 'when the start time is within business hours' do
        let(:from) { Time.new(2018, 02, 14, 11) } # 14 February 2018 is a Wednesday

        context 'when the end time is on the same day' do
          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 14, 16) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(5 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 14, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(6 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is on the following day and defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 15, 8) } # 15 February 2018 is a Thursday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(6 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 15, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(7 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 15, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(14 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is several days further and not defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 17, 8) } # 17 February 2018 is a Saturday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(22 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 17, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(22 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 17, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(22 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is several days further and defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 21, 8) } # 21 February 2018 is a Wednesday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(38 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 21, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(39 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 21, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(46 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end
      end

      context 'when the start time is after business hours' do
        let(:from) { Time.new(2018, 02, 14, 18) } # 14 February 2018 is a Wednesday

        context 'when the end time is on the same day' do
          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 14, 19) }

            it 'returns a zero duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(0)
            end
          end
        end

        context 'when the end time is on the following day and defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 15, 8) } # 15 February 2018 is a Thursday

            it 'returns a zero duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(0)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 15, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(1 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 15, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(8 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is several days further and not defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 17, 8) } # 17 February 2018 is a Saturday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(16 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 17, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(16 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 17, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(16 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end

        context 'when the end time is several days further and defined in the schedule' do
          context 'when the end time is before business hours' do
            let(:to) { Time.new(2018, 02, 21, 8) } # 21 February 2018 is a Wednesday

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(32 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is within business hours' do
            let(:to) { Time.new(2018, 02, 21, 10) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(33 * Sundial::SECONDS_PER_HOUR)
            end
          end

          context 'when the end time is after business hours' do
            let(:to) { Time.new(2018, 02, 21, 19) }

            it 'returns the correct duration' do
              expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(40 * Sundial::SECONDS_PER_HOUR)
            end
          end
        end
      end
    end

    context 'when the start time is on a day not defined in the schedule' do
      let(:from) { Time.new(2018, 02, 18, 6) } # 18 February 2018 is a Sunday

      context 'when the end time is on the same day' do
        it 'returns a zero duration' do
          expect(time_difference.elapsed(from, Time.new(2018, 02, 18, 8))).to eq Sundial::Duration.new(0)
          expect(time_difference.elapsed(from, Time.new(2018, 02, 18, 10))).to eq Sundial::Duration.new(0)
          expect(time_difference.elapsed(from, Time.new(2018, 02, 18, 19))).to eq Sundial::Duration.new(0)
        end
      end

      context 'when the end time is on the following day and defined in the schedule' do
        context 'when the end time is before business hours' do
          let(:to) { Time.new(2018, 02, 19, 8) } # 19 February 2018 is a Monday

          it 'returns a zero duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(0)
          end
        end

        context 'when the end time is within business hours' do
          let(:to) { Time.new(2018, 02, 19, 10) }

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(1 * Sundial::SECONDS_PER_HOUR)
          end
        end

        context 'when the end time is after business hours' do
          let(:to) { Time.new(2018, 02, 19, 19) }

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(8 * Sundial::SECONDS_PER_HOUR)
          end
        end
      end

      context 'when the end time is several days further and not defined in the schedule' do
        context 'when the end time is before business hours' do
          let(:to) { Time.new(2018, 02, 24, 8) } # 24 February 2018 is a Saturday

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(40 * Sundial::SECONDS_PER_HOUR)
          end
        end

        context 'when the end time is within business hours' do
          let(:to) { Time.new(2018, 02, 24, 10) }

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(40 * Sundial::SECONDS_PER_HOUR)
          end
        end

        context 'when the end time is after business hours' do
          let(:to) { Time.new(2018, 02, 24, 19) }

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(40 * Sundial::SECONDS_PER_HOUR)
          end
        end
      end

      context 'when the end time is several days further and defined in the schedule' do
        context 'when the end time is before business hours' do
          let(:to) { Time.new(2018, 02, 21, 8) } # 21 February 2018 is a Wednesday

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(16 * Sundial::SECONDS_PER_HOUR)
          end
        end

        context 'when the end time is within business hours' do
          let(:to) { Time.new(2018, 02, 21, 10) }

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(17 * Sundial::SECONDS_PER_HOUR)
          end
        end

        context 'when the end time is after business hours' do
          let(:to) { Time.new(2018, 02, 21, 19) }

          it 'returns the correct duration' do
            expect(time_difference.elapsed(from, to)).to eq Sundial::Duration.new(24 * Sundial::SECONDS_PER_HOUR)
          end
        end
      end
    end
  end
end
