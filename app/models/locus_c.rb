class LocusC < Hla

  def self.import(table)
    imported = 0
    invalid = 0
    existent = 0
    if where(patient_id: table["patient_id"]).count < 2
      locusc = new
      locusc.attributes = table
      if locusc.valid?
        locusc.save!
        imported += 1
      else
        invalid += 1
      end
    else
      existent += 1
    end
    if table["serotype"] == "00" then
      imported, invalid, existent = 0, 1, 0
    end
    return imported, invalid, existent
  end
end
