class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v8.1.4.tar.gz"
  sha256 "970be2acce6aadf003c018d4e47daab0d609b390f39fa245c04a35c7dac75950"
  license "Apache-2.0"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # We check the Git tags instead of using the `GithubLatest` strategy, as the
  # "latest" version can be incorrect. As of writing, two major versions of
  # `teleport` are being maintained side by side and the "latest" tag can point
  # to a release from the older major version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "906b221388010de831937ab8dd5055b72ba49358fc1f3b7064e952fca9c18d6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b76de37b23839f8b724228a7180dd9fac64d7cbbb68db43efb604db8ebc3b5f"
    sha256 cellar: :any_skip_relocation, monterey:       "5fb049896b5b0d8087dca7cb42a31d9a50c962a1c06c9035b8988901d44767c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2728db568c2c53497a10b892cd0602153ec9bfd6af40768c66767cdba330ab86"
    sha256 cellar: :any_skip_relocation, catalina:       "292ce9346548d88859a78e9fe81e2ec53797a9778dfe066c9cc2d177f5ac33b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a947015713da9f6b45d0a4ac6e269f93810bff3be9aa4855b0b53e7a4ca87129"
  end

  depends_on "go" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/ea3c67c941c56cfb6c228612e88100df09fb6f9c.tar.gz"
    sha256 "66812b99e4cc00d34fb2b022ffe9d5e13abb740a165fcf3f518dada52c631c51"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full" }
    bin.install Dir["build/*"]
  end

  test do
    webassets = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match resource("webassets").version.to_s, webassets
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~EOS
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    EOS

    fork do
      exec "#{bin}/teleport start --roles=proxy,node,auth --config=#{testpath}/config.yml"
    end

    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl --config=#{testpath}/config.yml status")
    assert_match(/Cluster\s*testhost/, status)
    assert_match(/Version\s*#{version}/, status)
  end
end
