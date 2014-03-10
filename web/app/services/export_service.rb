class ExportService
  def all
    Export.all
  end

  def find(export_id)
    Export.find(export_id)
  end

  def create(employer_id)
    Export.create(employer_id: employer_id.to_i)
  end

  def generate_file(export_id)
    ExportedFile.create(export_id: export_id.to_i)
  end
end
