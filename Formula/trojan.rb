class Trojan < Formula
  desc "Proxy utility"
  homepage "https://github.com/trojan-gfw/trojan"
  url "https://github.com/trojan-gfw/trojan/archive/v1.16.0.tar.gz"
  sha256 "86cdb2685bb03a63b62ce06545c41189952f1ec4a0cd9147450312ed70956cbc"
  license "GPL-3.0"
  head "https://github.com/trojan-gfw/trojan.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  def install
    system "cmake", ".",
                    "-DMYSQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMYSQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    *std_cmake_args 
    system "make", "install"
  end

  test do
    server_port = free_port
    local_port = free_port
    key = testpath/"key.pem"
    cert = testpath/"cert.pem"

    system "yes '' | openssl req -x509 -newkey rsa:2048 -keyout #{key} -out #{cert} -days 1 -nodes"

    (testpath/"server.json").write <<~EOS
      {
        "run_type": "server",
        "local_addr": "127.0.0.1",
        "local_port": #{server_port},
        "remote_addr": "127.0.0.1",
        "remote_port": 80,
        "password": ["test-password"],
        "ssl": {
          "cert": "#{cert}",
          "key": "#{key}"
        }
      }
    EOS
    (testpath/"client.json").write <<~EOS
      {
        "run_type": "client",
        "local_addr": "127.0.0.1",
        "local_port": #{local_port},
        "remote_addr": "127.0.0.1",
        "remote_port": #{server_port},
        "password": ["test-password"],
        "ssl": {
          "verify": false,
          "verify_hostname": false
        }
      }
    EOS
    server = fork { exec bin/"trojan", "-c", testpath/"server.json" }
    client = fork { exec bin/"trojan", "-c", testpath/"client.json" }
    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{local_port}", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end
end

