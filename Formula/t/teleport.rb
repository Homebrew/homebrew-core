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
    sha256 cellar: :any, arm64_tahoe:   "99c9ddd6177a247db329b1b08e417d653a7c41270e97ff714558fc694b593ea2"
    sha256 cellar: :any, arm64_sequoia: "142340f428e131a5634830484c5499426b3c9b26e3c85ddc69992ef0c20e10b2"
    sha256 cellar: :any, arm64_sonoma:  "773a21d3681278677f591d9c4c3f5fa37806c5c3f9c674ebf2e68734ebf31522"
    sha256 cellar: :any, sonoma:        "5e8235a2fc9959b9e066b82eb7a6446027051edc034bb8a2f93de13027edd4c1"
    sha256 cellar: :any, arm64_linux:   "4a83f639d7ddd80bb57929a5937dd0c37a5aec093531796bf2bd2eeec8c26455"
    sha256 cellar: :any, x86_64_linux:  "7178fa4eb6da2c632f5c522c85c1e5dedf9cb9121f4c62dae2b3c1e0312b5ed8"
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

    # wasm-bindgen 0.2.100+ needs the ironrdp wasm built with reference-types intrinsics
    inreplace "Makefile",
              %q(RUSTFLAGS='--cfg getrandom_backend="wasm_js"'),
              %q(RUSTFLAGS='--cfg getrandom_backend="wasm_js" -C target-feature=+reference-types')

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
