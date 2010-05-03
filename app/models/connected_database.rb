class ConnectedDatabase < ActiveRecord::Base
  establish_connection :connected_database
  
  @sql = ActiveRecord::Base.connection
  
  def create_database
    @sql.execute "CREATE DATABASE `lala2`"
  end
end
