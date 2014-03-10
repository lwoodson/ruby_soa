require 'grape'


class Exports < Grape::API
  format :json

  resource :exports do
    get do
      Export.all.map do |export|
        # THIS IS WONKY
        # have to extend and convert to hash for grape to work
        # May be a bug
        export.extend(ExportRepresenter).to_hash
      end
    end

    get ':id' do
      Export.find(params[:id]).extend(ExportRepresenter)
    end

    post do
      Export.create!(employer_id: params[:employer_id]).extend(ExportRepresenter)
    end
  end

  resource :exported_files do
    get do
      ExportedFile.all
    end

    get ':id' do
      ExportedFile.find(params[:id])
    end

    post do
      ExportedFile.create!(export_id: params[:export_id])
    end
  end
end
