class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.8.0.tar.gz"
  sha256 "13a09c342f2dccdc615471ff0f9be86149f96883662ac3bd685cb2115243068c"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
  revision 1
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
    sha256 cellar: :any,                 arm64_tahoe:   "dbcb033d375cb02ee7bb3495dec409c965aa64ee758f90b987b6c67b63b395a8"
    sha256 cellar: :any,                 arm64_sequoia: "0d51cf2421068405ef5d397f83b8b8af4865fa81c790fbabb953f2a9d8dafbcc"
    sha256 cellar: :any,                 arm64_sonoma:  "359737a39b768f305056d21f3c3965ea3006e384c25754a794a7c864c289acac"
    sha256 cellar: :any,                 sonoma:        "73fdf52371a91e42e42dcff0ec583b77edae08790457ca972b20e443acb382ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "031bf110e351fb89affd094fb0a0e2c8f6765436a74e1aceb20f6b0ba555fa1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07220b321a0faf8c54c3d1c91f37b4b76893cf4c151730c947a2b13d970b0c2b"
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
