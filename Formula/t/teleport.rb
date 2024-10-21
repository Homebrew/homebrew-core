class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v16.4.3.tar.gz"
  sha256 "12056687817def9fba016304fd9b992a0e1ba25db92b3b09f7712f351be78dce"
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
    sha256 cellar: :any,                 arm64_sequoia: "5ab37c65a67d7b8d99472d123a27adc2ee025f8555615873d31586f4ab2c5407"
    sha256 cellar: :any,                 arm64_sonoma:  "c258cc2c00cf463d1a4b151ff9d8fe04d50a11775c562fc5c8e0c831de32d72b"
    sha256 cellar: :any,                 arm64_ventura: "fb27c5e57c4b94c415bb30772fca3ef831b518bcf4efbc17e208ac2f9dbfd354"
    sha256 cellar: :any,                 sonoma:        "0223e30b94960716e8523bee93eaad384fb2b2ba640d3479357dce8eb99cf15a"
    sha256 cellar: :any,                 ventura:       "400b1be50ddbf0bb3debdb227e5d5143a66bd4194f3748e895b6044213d140fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bedbc19f8b054f1c50d46b463ee4563403cb63895939d117ec386d68610eb26e"
  end

  # Use "go" again after https://github.com/gravitational/teleport/commit/e4010172501f0ed18bb260655c83606dfa872fbd
  # is released, likely in a version 17.x.x (or later?):
  depends_on "go@1.22" => :build
  depends_on "pkg-config" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "wasm-pack" => :build
  depends_on "libfido2"
  depends_on "node"
  depends_on "openssl@3"

  uses_from_macos "curl" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

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
