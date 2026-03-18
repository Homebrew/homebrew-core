class Shibudb < Formula
  desc "Lightweight database engine with vector search support"
  homepage "https://github.com/shibudb-org/shibudb-server"
  url "https://github.com/shibudb-org/shibudb-server/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "91b31feb697624aeccbce5a3ac201ef6cb2d706c48a54b78bfb3fd1e56a3ecb1"
  license "AGPL-3.0-only"
  head "https://github.com/shibudb-org/shibudb-server.git", branch: "main"

  depends_on "go" => :build
  # faiss ships libfaiss.dylib + libfaiss_c.dylib + c_api headers
  # and transitively brings in libomp
  depends_on "faiss"

  def install
    faiss = Formula["faiss"]

    # Allow go build to download missing modules (no vendor dir in source tree)
    ENV["GOFLAGS"] = "-mod=mod"

    # Wire CGO to Homebrew's faiss instead of bundled prebuilt libraries
    ENV["CGO_ENABLED"] = "1"
    ENV.append "CGO_CFLAGS",   "-I#{faiss.opt_include}"
    ENV.append "CGO_CXXFLAGS", "-I#{faiss.opt_include}"
    ENV.append "CGO_LDFLAGS",
               "-L#{faiss.opt_lib} -lfaiss_c -lfaiss -Wl,-rpath,#{faiss.opt_lib}"

    ldflags = "-s -w -X main.Version=#{version}"

    system "go", "build",
           *std_go_args(ldflags: ldflags, output: bin/"shibudb"),
           "-tags=faiss",
           "."
  end

  def caveats
    <<~EOS
      The default service admin credentials are admin/admin.
      Change the admin password after first start:
        #{opt_bin}/shibudb connect 9090
        > update-user-password admin
    EOS
  end

  service do
    run [
      opt_bin/"shibudb", "run",
      "--data-dir", var/"lib/shibudb",
      "--admin-user", "admin",
      "--admin-password", "admin",
      "9090"
    ]
    keep_alive true
    log_path var/"log/shibudb.log"
    error_log_path var/"log/shibudb.log"
    working_dir var
  end

  test do
    assert_match "ShibuDB version #{version}", shell_output("#{bin}/shibudb --version")

    port = free_port
    data_dir = testpath/"shibudb-data"
    data_dir.mkpath

    pid = spawn(
      bin/"shibudb", "run",
      "--data-dir", data_dir.to_s,
      "--admin-user", "testadmin",
      "--admin-password", "testpass",
      port.to_s
    )
    # Wait for the server to accept TCP connections (slower on some CI, incl. ARM)
    require "socket"
    start = Time.now
    ready = false
    while Time.now - start < 30
      begin
        TCPSocket.open("127.0.0.1", port).close
        ready = true
        break
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        sleep 1
      end
    end

    begin
      assert_equal true, ready, "server did not become ready on port #{port}"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
