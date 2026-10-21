class Teleport < Formula
  desc "Modern SSH server for teams managing distributed infrastructure"
  homepage "https://goteleport.com/"
  # Check https://goteleport.com/download/ for valid versions as some git tags
  # aren't marked as GitHub releases but they correspond to official release
  url "https://github.com/gravitational/teleport/archive/refs/tags/v18.11.1.tar.gz"
  sha256 "a95bddd445dc3f93d91493b48e73d39959bbc4d4d00cd93fea34b3d02c3ba1da"
  license all_of: ["AGPL-3.0-or-later", "Apache-2.0"]
  head "https://github.com/gravitational/teleport.git", branch: "master"

  # Teleport first does a commercial release and then has a delayed open-source
  # git tag. Not all tags are marked as GitHub releases so we check that the
  # tag has a corresponding official release version.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      data = JSON.parse(Homebrew::Livecheck::Strategy.page_content("https://rlz.teleport.sh/versions")[:content])
      released_versions = data.fetch("supportedMajors", []).flat_map { |major| data.dig("versions", major) }
      tagged_versions = tags.filter_map { |tag| tag[regex, 1] }
      tagged_versions & released_versions
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "da2f7c8fa46d84d0957c7777c14343a9c7b1039be7e119bc666679bd2537570f"
    sha256 cellar: :any, arm64_tahoe:       "018ee4bde41991312b0ce6f4f6d2ab9a4f0365a98b26b95d37f1dade7e20e8af"
    sha256 cellar: :any, arm64_sequoia:     "6b8e20ec6a6bbb3c3e03a304789c024110652cd2099829bcc3a94a2c6c636727"
    sha256 cellar: :any, arm64_linux:       "f034f4b97e8e5c3835ff39bd96ffa679adb59f7bd203785a688a388bec40026a"
    sha256 cellar: :any, x86_64_linux:      "dbc3d27767400c5eb8e66b798a2d0f0575a5f1d92b25e1c758fee129c2992b4e"
  end

  depends_on "binaryen" => :build
  # TODO: unpin go@1.26 when teleport bumps `charlievieth/strcase` to v0.0.6+
  # ref: https://github.com/gravitational/teleport/pull/6880
  depends_on "go@1.26" => :build
  depends_on "lld" => :build
  depends_on "llvm" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "rust-wasm" => :build
  depends_on "libfido2"

  conflicts_with "etsh", because: "both install `tsh` binaries"
  conflicts_with "tctl", because: "both install `tctl` binaries"

  resource "wasm-bindgen" do
    url "https://static.crates.io/crates/wasm-bindgen-cli/wasm-bindgen-cli-0.2.122.crate"
    sha256 "c1686f9fe038f84b892c10d3b7489b291eb110537450159eb97e5f846b3045bc"

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

    resource("wasm-bindgen").stage do
      system "cargo", "install", *std_cargo_args(root: buildpath)
    end
    ENV.prepend_path "PATH", buildpath/"bin"

    # Reduce overlinking with OpenSSL
    ENV.append "CGO_LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    # Avoid passing incorrect target-cpu to wasm
    ENV.delete "HOMEBREW_RUSTFLAGS"

    # Build C code in wasm crates with LLVM as the host `CC` (GCC on Linux) cannot target wasm
    ENV["CC_wasm32_unknown_unknown"] = formula_opt_bin("llvm")/"clang"
    ENV["AR_wasm32_unknown_unknown"] = formula_opt_bin("llvm")/"llvm-ar"

    # Workaround for error: The CPU Jitter random number generator must not be compiled with optimizations.
    # Issue ref: https://github.com/aws/aws-lc-rs/issues/1097
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"

    # Linux-only `teleport-update` needs Teleport's signing keys; without them it refuses all updates
    ENV["TELEPORT_UPDATE_DEV_BUILD"] = "1" if OS.linux?

    inreplace "Makefile" do |s|
      # Workaround for Homebrew's installation layout as rust cannot find rust-wasm
      s.gsub! %q(RUSTFLAGS='--cfg getrandom_backend="wasm_js"'),
              %Q(RUSTFLAGS='--cfg getrandom_backend="wasm_js" --sysroot #{HOMEBREW_PREFIX} --codegen linker=wasm-ld')

      # avoid building another wasm-opt
      s.gsub!(/^(ensure-wasm-deps: .*) ensure-wasm-opt( .*)?$/, "\\1\\2")
    end

    # TODO: Makefile expects git clone but not possible while private enterprise submodule is referenced:
    # https://github.com/gravitational/teleport/commit/dbf752d73b99639cd9b64cfd9fef047806f61863
    inreplace "integrations/terraform-modules/gen/docs.sh",
              "$(git rev-parse --show-prefix)",
              "integrations/terraform-modules/gen/"

    ENV.deparallelize { system "make", "full", "FIDO2=dynamic", "LLVM_DIR=#{formula_opt_prefix("llvm")}" }
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
