class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.10.0.tar.gz"
  sha256 "75a6018ebb6e7e5ffc9f74ee6a5352dc1d5a3390f5617945cbef4f1a45f614e5"
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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "d179902fc3daf073e5d2c263dca2b4e059b0d153b3deda0bb81033719b21b363"
    sha256 cellar: :any, arm64_tahoe:       "824eb2ce8626174ac5b5d68185743d5d12479f7b65e0b06c6c64a1ec45b930df"
    sha256 cellar: :any, arm64_sequoia:     "ab68ce1341b9d143f58037ae8fc6fadeaedd8abef59a6e90ccc02bb2cd6ca76c"
    sha256 cellar: :any, arm64_linux:       "ea148eef1212beef1063305a4f5e71f6c65466034198ad927034573bf9097c90"
    sha256 cellar: :any, x86_64_linux:      "698c0f9ef4995295bb77b65f083f8912e7458894c85b8c427dcb1f81d138e5db"
  end

  depends_on "binaryen" => :build
  # TODO: unpin go@1.26 when teleport bumps `charlievieth/strcase` to v0.0.6+
  # ref: https://github.com/gravitational/teleport/pull/6880
  depends_on "go@1.26" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  # TODO: try to remove rustup dependancy, see https://github.com/Homebrew/homebrew-core/pull/191633#discussion_r1774378671
  depends_on "rustup" => :build
  depends_on "libfido2"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

  resource "wasm-bindgen" do
    url "https://github.com/wasm-bindgen/wasm-bindgen/archive/refs/tags/0.2.122.tar.gz"
    sha256 "3ea60c7c7dffbd4ea1898c5a0046c6ccd4a53d5638f231238936b5464e49d161"

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

    ENV.prepend_path "PATH", formula_opt_bin("rustup")
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

    inreplace "Makefile" do |s|
      # wasm-bindgen 0.2.100+ needs the ironrdp wasm built with reference-types intrinsics
      s.gsub! %q(RUSTFLAGS='--cfg getrandom_backend="wasm_js"'),
              %q(RUSTFLAGS='--cfg getrandom_backend="wasm_js" -C target-feature=+reference-types')

      # avoid building another wasm-opt
      s.gsub!(/^(ensure-wasm-deps: .*) ensure-wasm-opt( .*)?$/, "\\1\\2")
    end

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
