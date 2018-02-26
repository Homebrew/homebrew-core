require "language/go"

class Vitess < Formula
  desc "Database clustering system for horizontal scaling of MySQL"
  homepage "http://vitess.io"

  url "https://github.com/youtube/vitess.git",
      :revision => "08d7b71256567b1880ba4a63381ab58908967572"
  version "2.1.1.08d7b71"
  head "https://github.com/youtube/vitess.git"

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  go_resource "github.com/kardianos/govendor" do
    url "https://github.com/kardianos/govendor.git",
        :tag => "v1.0.9"
  end

  def install
    ENV["GOPATH"] = buildpath

    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/github.com/youtube/vitess").install contents

    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/kardianos/govendor" do
      system "go", "install"
    end

    cd "src/github.com/youtube/vitess" do
      system "govendor", "sync"

      system "make", "build"
      prefix.install "web"
    end

    %w[vtclient
       vtcombo
       vtctl
       vtctlclient
       vtctld
       vtexplain
       vtgate
       vtqueryserver
       vttablet
       vtworker
       vtworkerclient].each do |binary|
      bin.install "bin/#{binary}"
    end
  end

  test do
    begin
      pid = fork do
        exec bin/"vtcombo",
             "-port=15900",
             "-mycnf_server_id", "1",
             "-web_dir", "#{prefix}/web/vtctld",
             "-web_dir2", "#{prefix}/web/vtctld2/app"
      end
      sleep 1
      output = shell_output("curl -I 127.0.0.1:15900/app2/")
      assert_match "200 OK", output
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
