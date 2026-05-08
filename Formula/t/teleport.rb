class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.7.6.tar.gz"
  sha256 "30fb59382ba7e52f799c4ac3f950b3d7a4fbdfba2a826c8789c4ec4ac8e08f8c"
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
    sha256 cellar: :any,                 arm64_tahoe:   "b4b9df4c5ba17babe93352cf25e73aced6e4ed0d86f4a393672ee473ea63ff5b"
    sha256 cellar: :any,                 arm64_sequoia: "efc941f612d387b46bba9a408f2c11facbb15b58a6cd336174e4a3f417a96c6c"
    sha256 cellar: :any,                 arm64_sonoma:  "e8ac1dad84b0763b80df169c435634eb926b081884bd53c919c55deb29c966c0"
    sha256 cellar: :any,                 sonoma:        "fc5c40b3bdbf1124e7da9575daf43f58365a8d66a8334f0a0ad80d20bebab97a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55c40800f2b336d8f99aa0f09b1a7d6c3b817e33f2ae0178b74f24263f81bfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee0c21b593b301bb8a88f92cb097970d2380ff2d6a8dc62cb13ef482ed74bf30"
  end

  depends_on "binaryen" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "libfido2"
  depends_on "openssl@3"

  uses_from_macos "zip"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"
  conflicts_with cask: "teleport-suite"
  conflicts_with cask: "teleport-suite@17"
  conflicts_with cask: "teleport-suite@16"
  conflicts_with cask: "tsh", because: "both install `tsh` binaries"

  resource "wasm-bindgen" do
    url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.99.tar.gz"
    sha256 "1df06317203c9049752e55e59aee878774c88805cc6196630e514fa747f921f2"

    livecheck do
      url "https://raw.githubusercontent.com/gravitational/teleport/refs/tags/v#{LATEST_VERSION}/Cargo.lock"
      regex(/name\s*=\s*"wasm-bindgen".*?version\s*=\s*["'](\d+(?:\.\d+)+)["']/im)
    end
  end

  # disable `wasm-opt` for ironrdp pkg release build, upstream pr ref, https://github.com/gravitational/teleport/pull/50178
  patch :DATA

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Prevent pnpm from downloading another copy due to `packageManager` feature
    (buildpath/"pnpm-workspace.yaml").append_lines <<~YAML
      managePackageManagerVersions: false
    YAML

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    resource("wasm-bindgen").stage do
      system "cargo", "install", *std_cargo_args(path: "crates/cli", root: buildpath)
    end

    # Replace wasm-bindgen binary call to the built one
    inreplace "Makefile", "wasm-bindgen target", buildpath/"bin/wasm-bindgen target"

    # Workaround for error: The CPU Jitter random number generator must not be compiled with optimizations.
    # Issue ref: https://github.com/aws/aws-lc-rs/issues/1097
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

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
