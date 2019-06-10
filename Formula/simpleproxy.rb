require "socket"

class Simpleproxy < Formula
  desc "Simple TCP proxy"
  homepage "https://github.com/vzaliva/simpleproxy/"
  url "https://github.com/vzaliva/simpleproxy/archive/v.3.5.tar.gz"
  sha256 "035f2fef6fe56a69945e7e6fd7cb42490575b405197891d14d6515d20ed5bd93"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    server_port = 0
    proxy_port = 0
    while server_port == proxy_port
      server_port = rand(32768..64000)
      proxy_port = rand(32768..64000)
    end

    test_data = "Don't Panic\n"

    server_thread = Thread.new do
      server_socket = TCPServer.new("127.0.0.1", server_port)
      session = server_socket.accept
      data = session.gets
      if data != test_data
        raise Exception
      end

      Thread.exit
    end

    Kernel.spawn \
      "#{bin}/simpleproxy", \
      "-L", proxy_port.to_s, \
      "-R", "127.0.0.1:#{server_port}"

    timeout = 1
    client_socket = nil
    while client_socket.nil?
      begin
        client_socket = TCPSocket.new("127.0.0.1", proxy_port)
      rescue
        timeout -= 0.1
        sleep(0.1)
      end

      if timeout.zero?
        system "false"
      end
    end

    client_socket.puts(test_data)
    server_thread.join

    if server_thread.status.nil?
      system "false"
    else
      system "true"
    end
  end
end
