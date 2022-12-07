class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v11.1.2.tar.gz"
  sha256 "e9cda9f7a985a581c4e9197ea92cf525d7a2f74570ade5b19bb7d7a61d563c52"
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
    sha256 cellar: :any,                 arm64_ventura:  "9ecd3fedd50b5eb014118fe30b27ae7fa9bea59878ec6826716082004df50a45"
    sha256 cellar: :any,                 arm64_monterey: "05809ff7f33dd919a88ed9d886041e509ac7538fc899845adb2ed060bde030a2"
    sha256 cellar: :any,                 arm64_big_sur:  "ac7cb900c8ae5b2335d6f1dbd641f1ab234b32ec4d0127e85a6b59a4b0407213"
    sha256 cellar: :any,                 ventura:        "8eb7ab4fd706e4f87506349eed3282f7848bb7dae209cff2a6871be2cf7439bc"
    sha256 cellar: :any,                 monterey:       "55d98ae527c734e4f9217758f9a8712a4621e356a3219a3940af1f75b5af124e"
    sha256 cellar: :any,                 big_sur:        "a0943f5d3fca861f5b63b50afdbf18e3b466727fc4e82794f7b655360728d3d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb1366b989e750c785f1d0902af36d5dbb19926cc45460fd74d43a1c22615bc7"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "libfido2"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  # Keep this in sync with https://github.com/gravitational/teleport/tree/v#{version}
  resource "webassets" do
    url "https://github.com/gravitational/webassets/archive/56c3ba009a689f0119cadd9f832f4db7c0647ba4.tar.gz"
    sha256 "f98e1f0ab8e0d6d4a252afd8a52188f6fddb2afbf4ed29553c0e39c88e976003"
  end

  def install
    (buildpath/"webassets").install resource("webassets")
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    curl_output = shell_output("curl \"https://api.github.com/repos/gravitational/teleport/contents/webassets?ref=v#{version}\"")
    assert_match JSON.parse(curl_output)["sha"], resource("webassets").url
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
