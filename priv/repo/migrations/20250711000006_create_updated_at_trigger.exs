defmodule DndTracker.Repo.Migrations.CreateUpdatedAtTrigger do
  use Ecto.Migration

  def up do
    # Create the trigger function
    execute """
    CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
    BEGIN
        NEW.updated_at = CURRENT_TIMESTAMP;
        RETURN NEW;
    END;
    $$ language 'plpgsql';
    """

    # Create triggers for each table
    execute """
    CREATE TRIGGER update_adventures_updated_at 
    BEFORE UPDATE ON adventures 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    """

    execute """
    CREATE TRIGGER update_locations_updated_at 
    BEFORE UPDATE ON locations 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    """

    execute """
    CREATE TRIGGER update_npcs_updated_at 
    BEFORE UPDATE ON npcs 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    """

    execute """
    CREATE TRIGGER update_points_of_interest_updated_at 
    BEFORE UPDATE ON points_of_interest 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    """
  end

  def down do
    # Drop triggers
    execute "DROP TRIGGER IF EXISTS update_adventures_updated_at ON adventures;"
    execute "DROP TRIGGER IF EXISTS update_locations_updated_at ON locations;"
    execute "DROP TRIGGER IF EXISTS update_npcs_updated_at ON npcs;"
    execute "DROP TRIGGER IF EXISTS update_points_of_interest_updated_at ON points_of_interest;"
    
    # Drop function
    execute "DROP FUNCTION IF EXISTS update_updated_at_column();"
  end
end
