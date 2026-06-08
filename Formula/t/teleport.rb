class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.8.3.tar.gz"
  sha256 "6668a17367f750dc0a185277eaaa5f7cc8ff7c08f39d83a992eaf0b2b90a44c5"
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
    sha256 cellar: :any, arm64_tahoe:   "f0d08b8c55bef7f5103e6d8659a9fff18f240597f35a6a92766939a455053780"
    sha256 cellar: :any, arm64_sequoia: "70d7728e0fd0ed2c7ac2e1ce6625b7f03d3bba0d2ccd9438dcd57cde7aea1bfe"
    sha256 cellar: :any, arm64_sonoma:  "6f23593c6b4e2f3e6efd07009372c21a4827be680bc580b933a8ec172e929a89"
    sha256 cellar: :any, sonoma:        "d935277082c7cad27f01b78380bf5c6fb623807629c226db0576bc1df7bd318d"
    sha256 cellar: :any, arm64_linux:   "dd421904bec6a706ac00ce2a620367e72bc287c6085a514229c4bf36284d98a2"
    sha256 cellar: :any, x86_64_linux:  "1a60192a67e8fa192086cbbc2800030e10aa747c8683b0207ce82fde5d21e77b"
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
    ENV.prepend_path "PATH", buildpath/"bin"

    # Reduce overlinking with OpenSSL
    ENV.append "CGO_LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

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
