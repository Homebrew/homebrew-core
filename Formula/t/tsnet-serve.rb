class TsnetServe < Formula
  desc "Expose HTTP applications to a Tailscale Tailnet network"
  homepage "https://github.com/shayne/tsnet-serve"
  url "https://github.com/shayne/tsnet-serve/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "05d11ec7ac4e1bdb2ce6a8db3999e314ceab51ee7b462df3ec75895704438cc7"
  license "MIT"
  head "https://github.com/shayne/tsnet-serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8870b627f377c37f5bca645d1eaaead4fdedd84239dcfaf60d643d99668b4a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79d05ede181726fe1493fc6861d94f5fd5ecf115d63b43bfda78e75cea62928"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4858338aa9aa119ec3ffb6b6bcd8289b14c425643dc5cabb325d1f8569708c60"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a782710bea95a2736499ab7b1e1f371932956515f301d0a2ec80d4c43224c33e"
    sha256 cellar: :any_skip_relocation, sonoma:        "561db8d5942c4ece35f09fa0ad788448a816e2b0d5b9a3a0e05f91a40cbf5a5d"
    sha256 cellar: :any_skip_relocation, ventura:       "2caaa5230c882cdf6bca6ed21c5a92d17d2ce3380f7749685e324504f93efeb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "113ba6f73a541c717d6a026d6e24f598907ac49e0236e53029c2bdd62bd7b116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "040a566fb79644a0870e5f6b877e616555a92a148fbaff66cb327be3b62d8a1e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tsnet-serve -version")

    hostname = "test"
    backend = "http://localhost:8080"

    logfile = testpath/"tsnet-serve.log"
    pid = spawn bin/"tsnet-serve", "-hostname", hostname, "-backend", backend,
                out: logfile.to_s, err: logfile.to_s

    sleep 1

    output = logfile.read
    assert_match "tsnet starting with hostname \"#{hostname}\"", output
    assert_match "LocalBackend state is NeedsLogin", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
