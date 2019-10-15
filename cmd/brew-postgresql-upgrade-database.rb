#:  * `postgresql-upgrade-database`:
#:    Upgrades the database for the `postgresql` formula.

name = "postgresql"
pg = Formula[name]
bin = pg.bin
var = pg.var
version = pg.version
pg_version_file = var/"postgres/PG_VERSION"

pg_version_installed = version.to_s[/^\d+/]
pg_version_data = pg_version_file.read.chomp
if pg_version_installed == pg_version_data
  odie <<~EOS
    #{name} data already upgraded!
  EOS
end

datadir = var/"postgres"
old_datadir = var/"postgres.old"
if old_datadir.exist?
  odie <<~EOS
    #{old_datadir} already exists!
    Remove it if you want to upgrade data automatically.
  EOS
end

old_pg_name = "#{name}@#{pg_version_data}"
old_pg_glob = "#{HOMEBREW_PREFIX}/Cellar/#{old_pg_name}/#{pg_version_data}.*/bin"
old_bin = Pathname.glob(old_pg_glob).first
old_bin ||= begin
  Formula[old_pg_name]
  ohai "brew install #{old_pg_name}"
  system "brew", "install", old_pg_name
  Pathname.glob(old_pg_glob).first
rescue FormulaUnavailableError
  nil
end

odie "No #{name} #{pg_version_data}.* version installed!" unless old_bin

server_stopped = false
moved_data = false
initdb_run = false
upgraded = false

begin
  # Following instructions from:
  # https://www.postgresql.org/docs/10/static/pgupgrade.html
  ohai "Upgrading #{name} data from #{pg_version_data} to #{pg_version_installed}..."

  if /#{name}\s+started/.match?(Utils.popen_read("brew", "services", "list"))
    system "brew", "services", "stop", name
    service_stopped = true
  elsif quiet_system "#{bin}/pg_ctl", "-D", datadir, "status"
    system "#{bin}/pg_ctl", "-D", datadir, "stop"
    server_stopped = true
  end

  # get 'lc_collate' from old DB"
  unless quiet_system "#{old_bin}/pg_ctl", "-w", "-D", datadir, "status"
    system "#{old_bin}/pg_ctl", "-w", "-D", datadir, "start"
  end

  sql_for_lc_collate = "SELECT setting FROM pg_settings WHERE name LIKE 'lc_collate';"
  sql_for_lc_ctype = "SELECT setting FROM pg_settings WHERE name LIKE 'lc_ctype';"
  lc_collate = Utils.popen_read("#{old_bin}/psql", "postgres", "-qtAX", "-U", ENV["USER"], "-c", sql_for_lc_collate).strip
  lc_ctype = Utils.popen_read("#{old_bin}/psql", "postgres", "-qtAX", "-U", ENV["USER"], "-c", sql_for_lc_ctype).strip
  initdb_args = []
  initdb_args += ["--lc-collate", lc_collate] unless lc_collate.empty?
  initdb_args += ["--lc-ctype", lc_ctype] unless lc_ctype.empty?

  if quiet_system "#{old_bin}/pg_ctl", "-w", "-D", datadir, "status"
    system "#{old_bin}/pg_ctl", "-w", "-D", datadir, "stop"
  end

  ohai "Moving #{name} data from #{datadir} to #{old_datadir}..."
  FileUtils.mv datadir, old_datadir
  moved_data = true

  (var/"postgres").mkpath
  safe_system "#{bin}/initdb", *initdb_args, "#{var}/postgres"
  initdb_run = true

  (var/"log").cd do
    safe_system "#{bin}/pg_upgrade",
      "-r",
      "-b", old_bin,
      "-B", bin,
      "-d", old_datadir,
      "-D", datadir,
      "-j", Hardware::CPU.cores.to_s
  end
  upgraded = true

  ohai "Upgraded #{name} data from #{pg_version_data} to #{pg_version_installed}!"
  ohai "Your #{name} #{pg_version_data} data remains at #{old_datadir}"
ensure
  if upgraded
    if server_stopped
      safe_system "#{bin}/pg_ctl", "-D", datadir, "start"
    elsif service_stopped
      safe_system "brew", "services", "start", name
    end
  else
    onoe "Upgrading #{name} data from #{pg_version_data} to #{pg_version_installed} failed!"
    if initdb_run
      ohai "Removing empty #{name} initdb database..."
      FileUtils.rm_r datadir
    end
    if moved_data
      ohai "Moving #{name} data back from #{old_datadir} to #{datadir}..."
      FileUtils.mv old_datadir, datadir
    end
    if server_stopped
      system "#{bin}/pg_ctl", "-D", datadir, "start"
    elsif service_stopped
      system "brew", "services", "start", name
    end
  end
end
