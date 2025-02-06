class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v17.2.1.tar.gz"
  sha256 "46fd244f799f89badf34850a9455bf202305f255e3178a5a36d4f5424d185b79"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
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
    sha256 cellar: :any,                 arm64_sequoia: "8da4b9698609a53b5bc62d080c94b0dde6e029f01d98a5387d00be17fad5a2a4"
    sha256 cellar: :any,                 arm64_sonoma:  "51d77528c504305c45fc99666f3d385cd6e538ad679d6b39ae41ac273dacd4ff"
    sha256 cellar: :any,                 arm64_ventura: "1407d45f7c7212c1d3fbabbd9a4d7916b9757449a2ebe5ab195b17b705a9ef3e"
    sha256 cellar: :any,                 sonoma:        "b65bb611e6bbfbff0573ced932d8754a5c0ba615505014d2c350262619462075"
    sha256 cellar: :any,                 ventura:       "5294480bb608e128d2286ddcae1b7823a87d72c97edee610d26ec0faacad5472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4510c99c2e1bc121e363a6928570fbb808427299a04e1136691e7677bbf32753"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "wasm-pack" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

  # disable `wasm-opt` for ironrdp pkg release build, upstream pr ref, https://github.com/gravitational/teleport/pull/50178
  patch do
    url "https://github.com/gravitational/teleport/commit/994890fb05360b166afd981312345a4cf01bc422.patch?full_index=1"
    sha256 "9d60180ff69a8a8985773d3b2a107ab910b22040e4cbf6afed11bd2b64fc6996"
  end

  def install
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    ENV.deparallelize { system "make", "full", "FIDO2=dynamic" }
    bin.install Dir["build/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teleport version")
    assert_match version.to_s, shell_output("#{bin}/tsh version")
    assert_match version.to_s, shell_output("#{bin}/tctl version")

    mkdir testpath/"data"
    (testpath/"config.yml").write <<~YAML
      version: v2
      teleport:
        nodename: testhost
        data_dir: #{testpath}/data
        log:
          output: stderr
          severity: WARN
    YAML

    spawn bin/"teleport", "start", "--roles=proxy,node,auth", "--config=#{testpath}/config.yml"
    sleep 10
    system "curl", "--insecure", "https://localhost:3080"

    status = shell_output("#{bin}/tctl status --config=#{testpath}/config.yml")
    assert_match(/Cluster:\s*testhost/, status)
    assert_match(/Version:\s*#{version}/, status)
  end
end
