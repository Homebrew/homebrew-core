class Seekdb < Formula
  desc "AI-Native Search Database - OceanBase SeekDB"
  homepage "https://github.com/oceanbase/seekdb"
  url "https://mirrors.aliyun.com/oceanbase/community/stable/darwin/15/arm64/seekdb-1.1.0.0-beta-macos15-arm64.tar.gz"
  version "1.1.0.0"
  sha256 "37de2d65b5eccdc0ffb2bb8d9641c308d5a01d2abd2594eaf2b9e927fca99ad4"
  license "Apache-2.0"
  depends_on arch: :arm64
  depends_on "brotli"
  depends_on macos: :sequoia
  depends_on "re2"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"

  def install
    # Install binaries from usr/bin/
    bin.install "usr/bin/seekdb"
    bin.install "usr/bin/obshell"

    # Install config files from etc/seekdb/
    (etc/"seekdb").install Dir["etc/seekdb/*"]

    # Install helper scripts from usr/libexec/seekdb/
    (libexec/"seekdb").install Dir["usr/libexec/seekdb/*"]

    # Install share files from usr/share/seekdb/
    pkgshare.install Dir["usr/share/seekdb/*"]

    # Create data directories
    (var/"seekdb").mkpath
    (var/"seekdb/data").mkpath
    (var/"seekdb/data/run").mkpath
    (var/"seekdb/data/log").mkpath

    # Install helper scripts
    (bin/"seekdb-start").write start_script
    (bin/"seekdb-stop").write stop_script
    (bin/"seekdb-status").write status_script
    (bin/"seekdb-cleanup").write cleanup_script

    chmod 0755, bin/"seekdb-start"
    chmod 0755, bin/"seekdb-stop"
    chmod 0755, bin/"seekdb-status"
    chmod 0755, bin/"seekdb-cleanup"
  end

  def post_install
    chmod 0755, bin/"seekdb"
    chmod 0755, bin/"obshell"

    (var/"seekdb/run").mkpath
    (var/"seekdb/data").mkpath
  end

  def start_script
    <<~EOS
      #!/bin/bash

      SEEKDB_BIN="#{bin}/seekdb"
      OBSHELL_BIN="#{bin}/obshell"
      SEEKDB_DATA_DIR="#{var}/seekdb/data"
      SEEKDB_PID_FILE="#{var}/seekdb/data/run/seekdb.pid"
      SEEKDB_LOG_FILE="#{var}/seekdb/data/log/seekdb.log"
      DAEMON_PID_FILE="#{var}/seekdb/data/run/daemon.pid"

      # check if already running
      if [[ -f "$SEEKDB_PID_FILE" ]] && kill -0 "$(cat "$SEEKDB_PID_FILE")" 2>/dev/null; then
        echo "SeekDB is already running (PID: $(cat "$SEEKDB_PID_FILE"))"
        exit 1
      fi

      # ensure directories exist
      mkdir -p "$(dirname "$SEEKDB_PID_FILE")"
      mkdir -p "$(dirname "$SEEKDB_LOG_FILE")"
      mkdir -p "$SEEKDB_DATA_DIR"

      echo "Starting SeekDB..."
      echo "Data directory: $SEEKDB_DATA_DIR"
      echo "PID file: $SEEKDB_PID_FILE"
      echo "Log file: $SEEKDB_LOG_FILE"

      # start SeekDB
      "$SEEKDB_BIN" --base-dir="$SEEKDB_DATA_DIR" --parameter cpu_count=4 --parameter memory_limit=2G > "$SEEKDB_LOG_FILE" 2>&1 &

      # Loop to check startup status, wait up to 60 seconds
      MAX_WAIT=60
      WAITED=0
      echo "Waiting for SeekDB to start..."

      while [[ $WAITED -lt $MAX_WAIT ]]; do
        if [[ -f "$SEEKDB_PID_FILE" ]]; then
          SEEKDB_PID=$(cat "$SEEKDB_PID_FILE")
          if [[ -n "$SEEKDB_PID" ]] && kill -0 "$SEEKDB_PID" 2>/dev/null; then
            echo "SeekDB started successfully (PID: $SEEKDB_PID) in ${WAITED}s"
            echo -e "\\033[32mYou can connect via: mysql -h127.0.0.1 -uroot -P2881 -Doceanbase -A\\033[0m"
            sleep 2

            # Start obshell agent
            echo "Starting obshell agent..."
            rm -f "$DAEMON_PID_FILE"
            if "$OBSHELL_BIN" agent start --base-dir="$SEEKDB_DATA_DIR"; then
              echo "obshell agent started successfully"
              echo -e "\\033[32mYou can access the web interface at http://127.0.0.1:2886/\\033[0m"
              echo -e "\\033[33mNote: Initial root password is empty.\\033[0m"
            else
              echo "Failed to start obshell agent"
            fi

            exit 0
          fi
        fi
        sleep 1
        WAITED=$((WAITED + 1))
      done

      echo "Failed to start SeekDB within ${MAX_WAIT}s"
      rm -f "$SEEKDB_PID_FILE"
      exit 1
    EOS
  end

  def stop_script
    <<~EOS
      #!/bin/bash

      SEEKDB_PID_FILE="#{var}/seekdb/data/run/seekdb.pid"
      OBSHELL_PID_FILE="#{var}/seekdb/data/run/obshell.pid"
      DAEMON_PID_FILE="#{var}/seekdb/data/run/daemon.pid"

      # Stop obshell processes first (daemon first, then obshell)
      if [[ -f "$DAEMON_PID_FILE" ]]; then
        DAEMON_PID=$(cat "$DAEMON_PID_FILE")
        if kill -0 "$DAEMON_PID" 2>/dev/null; then
          echo "Stopping obshell daemon (PID: $DAEMON_PID)..."
          kill -9 "$DAEMON_PID" 2>/dev/null
          rm -f "$DAEMON_PID_FILE"
          echo "obshell daemon stopped"
        fi
      fi

      if [[ -f "$OBSHELL_PID_FILE" ]]; then
        OBSHELL_PID=$(cat "$OBSHELL_PID_FILE")
        if kill -0 "$OBSHELL_PID" 2>/dev/null; then
          echo "Stopping obshell (PID: $OBSHELL_PID)..."
          kill -9 "$OBSHELL_PID" 2>/dev/null
          rm -f "$OBSHELL_PID_FILE"
          echo "obshell stopped"
        fi
      fi

      if [[ ! -f "$SEEKDB_PID_FILE" ]]; then
        echo "SeekDB is not running (no PID file found)"
        exit 0
      fi

      SEEKDB_PID=$(cat "$SEEKDB_PID_FILE")

      if ! kill -0 "$SEEKDB_PID" 2>/dev/null; then
        echo "SeekDB is not running (stale PID file)"
        rm -f "$SEEKDB_PID_FILE"
        exit 0
      fi

      echo "Stopping SeekDB (PID: $SEEKDB_PID)..."

      # force stop
      echo "Force stopping SeekDB..."
      kill -KILL "$SEEKDB_PID" 2>/dev/null
      rm -f "$SEEKDB_PID_FILE"
      echo "SeekDB force stopped"
    EOS
  end

  def status_script
    <<~EOS
      #!/bin/bash

      SEEKDB_PID_FILE="#{var}/seekdb/data/run/seekdb.pid"

      if [[ ! -f "$SEEKDB_PID_FILE" ]]; then
        echo "SeekDB is not running"
        exit 1
      fi

      SEEKDB_PID=$(cat "$SEEKDB_PID_FILE")

      if kill -0 "$SEEKDB_PID" 2>/dev/null; then
        echo "SeekDB is running (PID: $SEEKDB_PID)"

        # show more information
        echo "Data directory: #{var}/seekdb/data"
        echo "PID file: $SEEKDB_PID_FILE"
        echo "Log file: #{var}/seekdb/data/log/seekdb.log"

        # show process information
        ps -p "$SEEKDB_PID" -o pid,ppid,pcpu,pmem,etime,command
      else
        echo "SeekDB is not running (stale PID file)"
        rm -f "$SEEKDB_PID_FILE"
        exit 1
      fi
    EOS
  end

  def cleanup_script
    <<~EOS
      #!/bin/bash

      echo "This will remove all SeekDB configuration and data files."
      echo "Directories to be removed:"
      echo "  - #{etc}/seekdb"
      echo "  - #{var}/seekdb"
      echo ""
      read -p "Are you sure you want to continue? (y/N) " -n 1 -r
      echo ""

      if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Stop SeekDB if running
        if command -v seekdb-stop &> /dev/null; then
          seekdb-stop 2>/dev/null || true
        fi

        # Remove directories
        rm -rf "#{etc}/seekdb"
        rm -rf "#{var}/seekdb"

        echo "SeekDB data and configuration have been removed."
        echo "You can now run: brew uninstall seekdb"
      else
        echo "Cleanup cancelled."
      fi
    EOS
  end

  def caveats
    <<~EOS
      SeekDB has been installed successfully!
      Manual control commands(recommended):
        seekdb-start   # Start SeekDB daemon
        seekdb-stop    # Stop SeekDB daemon
        seekdb-status  # Check SeekDB status
        seekdb-cleanup # Remove config and data directories
      Direct usage:
        seekdb --nodaemon                    # Foreground mode (first startup is faster)
        seekdb --base-dir=/custom/path       # Custom data directory
      Files and directories:
        Config: #{etc}/seekdb
        Data:   #{var}/seekdb/data
        PID:    #{var}/seekdb/data/run/seekdb.pid
        Log:    #{var}/seekdb/data/log/seekdb.log
        Share:  #{share}/seekdb
      Complete uninstall:
        seekdb-cleanup                       # Remove config and data directories
        brew uninstall seekdb                # Uninstall SeekDB
      Note: If macOS blocks the application, allow it in System Preferences >
      Security & Privacy. First background startup may take ~10 seconds.
    EOS
  end

  test do
    system bin/"seekdb", "--version"
  end
end
