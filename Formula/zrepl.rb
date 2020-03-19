class Zrepl < Formula
  desc "One-stop ZFS backup & replication solution"
  homepage "https://zrepl.github.io"
  url "https://github.com/zrepl/zrepl/archive/v0.2.1.tar.gz"
  sha256 "df474e70f5a51d84816ee8a06038ded167a7548e547e2d2822c313f088eeeafd"
  head "https://github.com/zrepl/zrepl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "089ca444325890a214face9ea6de0cfc7de1a931ce126e4253f0c390c814fd67" => :catalina
    sha256 "0907d294ed2efe16891751914c03f869940b0c640e82ae11b882d50a60352dab" => :mojave
    sha256 "d480d224d1cfd259622de17f60d7f619f439e9cf37337a0a136fba827daa36d2" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  resource "sample_config" do
    url "https://raw.githubusercontent.com/zrepl/zrepl/master/config/samples/local.yml"
    sha256 "f27b21716e6efdc208481a8f7399f35fd041183783e00c57f62b3a5520470c05"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/zrepl/zrepl").install contents

    ENV["GOPATH"] = gopath
    ENV["GOOS"]   = "darwin"
    ENV["GOARCH"] = "amd64"

    ENV.prepend_create_path "PATH", gopath/"bin"
    cd gopath/"src/github.com/zrepl/zrepl" do
      system "go", "build", "-o", "'$GOPATH/bin/stringer'", "golang.org/x/tools/cmd/stringer"
      system "go", "build", "-o", "'$GOPATH/bin/protoc-gen-go'", "github.com/golang/protobuf/protoc-gen-go"
      system "go", "build", "-o", "'$GOPATH/bin/enumer'", "github.com/alvaroloes/enumer"
      system "go", "build", "-o", "'$GOPATH/bin/goimports'", "golang.org/x/tools/cmd/goimports"
      system "go", "build", "-o", "'$GOPATH/bin/golangci-lint'", "github.com/golangci/golangci-lint/cmd/golangci-lint"
      system "make", "ZREPL_VERSION=#{version}"
      bin.install "artifacts/zrepl-darwin-amd64" => "zrepl"
    end
  end

  def post_install
    (var/"log/zrepl").mkpath
    (var/"run/zrepl").mkpath
    (etc/"zrepl").mkpath
  end

  plist_options :startup => true, :manual => "sudo zrepl daemon"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:#{HOMEBREW_PREFIX}/bin</string>
          </dict>
          <key>KeepAlive</key>
          <true/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/zrepl</string>
            <string>daemon</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/zrepl/zrepl.err.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/zrepl/zrepl.out.log</string>
          <key>ThrottleInterval</key>
          <integer>30</integer>
          <key>WorkingDirectory</key>
          <string>#{var}/run/zrepl</string>
        </dict>
      </plist>
    EOS
  end

  test do
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      assert_equal "", shell_output("#{bin}/zrepl configcheck --config #{r.cached_download}")
    end
  end
end
