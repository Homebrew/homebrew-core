class ServerGo < Formula
  desc "Server for OpenIoTHub"
  homepage "https://github.com/OpenIoTHub/server-go"
  url "https://github.com/OpenIoTHub/server-go.git",
      tag:      "v1.1.77",
      revision: "1c096fa17a6b529bb0002c224c9b035df368f30e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "bfe52d99a8cc8580448ea469d8a1cd5368dc5ced07f3cc178875b364b3e3465a"
    sha256 cellar: :any_skip_relocation, catalina:     "8389ec52c3a4fb7529b1d1e9310df8e6c12db24ffe4ab44fe8bf9cb0a1384d5d"
    sha256 cellar: :any_skip_relocation, mojave:       "83da439668fa212832bbf590132d5e427b57f2ebc47180dcbb13a3b712686069"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b87d1299a13993027896fe90b1ad8542402f1631ba0e3fb5d15c180c6801e193"
  end

  depends_on "go" => :build

  def install
    (etc/"server-go").mkpath
    system "go", "build", "-mod=vendor", "-ldflags",
      "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew", *std_go_args
    etc.install "server-go.yaml" => "server-go/server-go.yaml"
  end

  service do
    run [opt_bin/"server-go", "-c", etc/"server-go/server-go.yaml"]
    keep_alive true
    log_path var/"log/server-go.log"
    error_log_path var/"log/server-go.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/server-go -v 2>&1")
    assert_match "config created", shell_output("#{bin}/server-go init --config=server.yml 2>&1")
    assert_predicate testpath/"server.yml", :exist?
  end
end
