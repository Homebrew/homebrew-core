class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.2.1.tar.gz"
  sha256 "2b995025c33785bcd9235c9ae079db26b2871e63547b53590a2b6836b79267fb"
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
    sha256 cellar: :any,                 arm64_tahoe:   "28e8e7794d1d3048c488185e5b2cd81d9e7ee2d7173523ccc57e992c4a9989ca"
    sha256 cellar: :any,                 arm64_sequoia: "736bba37aefc0d186126fc4d533ccbeb919b27905f17a5dd290a4dcc794c90a9"
    sha256 cellar: :any,                 arm64_sonoma:  "8e54d79b83e05ba5cb5ede58c5233a60c9063618dcf4b3c5bc03d03173081e4a"
    sha256 cellar: :any,                 sonoma:        "f750d8c12fdd9cc599b9f1ed68b6d1e00c6209dd5669a2d884fee75e2ed266a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "836877b81ffa082aaf5ee14ea35120968fe3b5326fe71149f59525c0a12a8609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d091ed7416cb13f11d63cd84923406092cebf9d733bbfd421522c76b5fe67940"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # node 24 support issue, https://github.com/gravitational/teleport/issues/57202
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "wasm-pack" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"
  conflicts_with cask: "teleport-suite"
  conflicts_with cask: "teleport-suite@17"
  conflicts_with cask: "teleport-suite@16"
  conflicts_with cask: "tsh", because: "both install `tsh` binaries"
  conflicts_with cask: "tsh@13", because: "both install `tsh` binaries"

  # disable `wasm-opt` for ironrdp pkg release build, upstream pr ref, https://github.com/gravitational/teleport/pull/50178
  patch :DATA

  def install
    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

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

__END__
diff --git a/web/packages/shared/libs/ironrdp/Cargo.toml b/web/packages/shared/libs/ironrdp/Cargo.toml
index ddcc4db..913691f 100644
--- a/web/packages/shared/libs/ironrdp/Cargo.toml
+++ b/web/packages/shared/libs/ironrdp/Cargo.toml
@@ -7,6 +7,9 @@ publish.workspace = true
 
 # See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html
 
+[package.metadata.wasm-pack.profile.release]
+wasm-opt = false
+
 [lib]
 crate-type = ["cdylib"]
