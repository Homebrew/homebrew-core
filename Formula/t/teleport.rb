class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.4.0.tar.gz"
  sha256 "52edd0ceaae28a8ed19e2e8a63be98d2c9092ac65b675303547d90abb4e03873"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e378df17852d550e5740d5936435f4c052d48ffd414d6bacebd38b031a978725"
    sha256 cellar: :any,                 arm64_sequoia: "f6a50c3862017932c69cab1c9241cc0961689448c95d4f961fb4e044e0f28895"
    sha256 cellar: :any,                 arm64_sonoma:  "b8cb2e5990f56d6255e385117b6bcca9eeba4378d4f567249e8368065b7336cc"
    sha256 cellar: :any,                 sonoma:        "157c9e413d4a2893db3b90c69ebb0ebe1a21b23290aaa09c7b467ff880003080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b443ffccbd5efe7df92eb10028e8a7463e1a72bb3bb4261b8edf3b7a7674e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b77d2da0c3eaad86c640e38094e86390458b5ed429b66d0f629cabeafe470d0b"
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
