require "prawn/measurement_extensions"

module RacePdfHelper
  def start_numbers_pdf(race)
    pdf = Prawn::Document.new(page_size: 'A4', page_layout: :landscape, margin: 4.cm, bottom_margin: 1.cm)
    
    
    race.runs_with_runners.each do |run|
      add_racer(pdf, run.runner.name, run.start_number, race)
      pdf.start_new_page
    end
    
    5.times do |i|
      add_racer(pdf, race.runs.map(&:start_number).max + i + 1, race)
      pdf.start_new_page
    end
    
    pdf.render
  end
  
  def add_racer(pdf, name = nil, start_number, race)
    pdf.font_size 250
    pdf.text start_number.to_s, align: :center
    pdf.move_up 50
    if name
      pdf.font_size 45
      pdf.text name, align: :center
    else
      pdf.move_down 45
    end
    pdf.move_down 100
    
    pdf.font_size 25
    pdf.text "#{race.name}, #{I18n.l race.time, format: :short}", align: :right
    pdf.font_size 12
    pdf.text race_url(race), align: :right
  end
end