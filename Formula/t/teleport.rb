class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v14.3.0.tar.gz"
  sha256 "9c5feff6d9743ed231c1e06a9fe6bd631df64c8a0f79ec381a516b7bab8feb03"
  license "AGPL-3.0-or-later"
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # As of writing, two major versions of `teleport` are being maintained
  # side by side and the "latest" release can point to an older major version,
  # so we can't use the `GithubLatest` strategy. We use the `GithubReleases`
  # strategy instead of `Git` because there is often a notable gap (days)
  # between when a version is tagged and released.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ae0bd82924559e34019d7fb456874c781906938d4396a13e44730fa315b057ee"
    sha256 cellar: :any,                 arm64_ventura:  "394c5f18bc04c5ca06a533e60a2d7535320a868064122402f648534caaa79e4f"
    sha256 cellar: :any,                 arm64_monterey: "24bff24f99484e50fd1d3b5f582c03de7a6c785278d74b1df35cc6b2476a5e09"
    sha256 cellar: :any,                 sonoma:         "4c585653054323265956373c687c738173705b2c842e40927314ac18bcc07906"
    sha256 cellar: :any,                 ventura:        "b9d8cd65728f74e28ac9519f2c5274bbb5046ea56ef28f9ebe8a8a6a41ea3548"
    sha256 cellar: :any,                 monterey:       "bf46c352713f76e8868f6f21e8d1532f3df2944b12fdc3251257900f07595e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48a6d258545e4ea1362decd58ce74c58da5362a2da0d04c07696c9dc4ca18998"
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "yarn" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"

  def install
    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
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
