class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://gravitational.com/teleport"
  url "https://github.com/gravitational/teleport/archive/v10.1.5.tar.gz"
  sha256 "94ce7459432430413c11a0edab37177f28836040ee5b00b912c3929686879db6"
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
    sha256 cellar: :any,                 arm64_monterey: "0d26efa4bf5409cf4739570af42817831d862cc2a6bcbf610ff1228b0701f08f"
    sha256 cellar: :any,                 arm64_big_sur:  "94c92729f0c3f3a495cc3ee03db5d7fd57bb7e2d7f684af4384e3868a2d538e9"
    sha256 cellar: :any,                 monterey:       "1d15987b1358bc63b86f7d0523f7240487b967de8df87556fb283ff9b81798e1"
    sha256 cellar: :any,                 big_sur:        "e8ec904a762cbd12fa399b89da4fe4193dab9774a76ed8c393f8030e248a03aa"
    sha256 cellar: :any,                 catalina:       "bdd2dc56285054ddf7bfbe685d2bbf0ca0dca5d5a889433988926f6408065148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1b665ef4fdcdc8dd086e5e56e2b655871ef38de6defd353a83df9511d9d1f78"
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
    url "https://github.com/gravitational/webassets/archive/55ad296b39fd272549a45536ee127306805434a8.tar.gz"
    sha256 "43e5b2403061e67817f51e552fee3c3c1058fccb989088ccfa62cf3e9bca9138"
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
