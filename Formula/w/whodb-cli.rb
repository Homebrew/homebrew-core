class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  license "Apache-2.0"

  stable do
    url "https://github.com/clidey/whodb/archive/refs/tags/0.135.0.tar.gz"
    sha256 "b1dc1a43c96d2ddc6743b13a2e492976d0f44a5bc9545bcc9dcf3a7aef7d7c9d"

    resource "baml" do
      url "https://github.com/BoundaryML/baml/archive/refs/tags/0.226.2.tar.gz"
      sha256 "09aa8182dd9bb674a6aa78733052b35720c2d9c763422e579fcd2b846f3e26b9"

      livecheck do
        url "https://raw.githubusercontent.com/clidey/whodb/#{LATEST_VERSION}/core/go.mod"
        regex(%r{github\.com/boundaryml/baml\s+v?(\d+(?:\.\d+)+)}i)
      end
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ba2a1891ffc13c2197519ecb86a68660a630cf3680164fd4a85d0b5e7f666911"
    sha256 cellar: :any, arm64_tahoe:       "f9e78124349ae260574b70ceffbe234f2c165fd8f5b95a3c0ba16da4f47ebfe3"
    sha256 cellar: :any, arm64_sequoia:     "96612d3ac525b8d1f6ce69ed52f5e2e08f7a2274239459703abccc897e41aca5"
    sha256 cellar: :any, arm64_linux:       "c21f7004ee96fef682090898d25f277d2e172ac7803992efb42761edbd1ab33a"
    sha256 cellar: :any, x86_64_linux:      "dba5dc162c84cb734a0b4e68d53beb3d6d715f6fb89643e4f5d707090e01ba63"
  end

  head do
    url "https://github.com/clidey/whodb.git", branch: "main"

    resource "baml" do
      url "https://github.com/BoundaryML/baml.git", branch: "main"
    end
  end

  depends_on "go" => :build
  depends_on "protoc-gen-go" => :build
  depends_on "rust" => :build

  deny_network_access!

  def baml_version
    File.read("core/go.mod")[%r{github\.com/boundaryml/baml\s+v?(\d+(?:\.\d+)+)}i, 1]
  end

  def fetch
    resource("baml").stage("baml")
    system "git", "-C", "baml", "checkout", baml_version if build.head?
    system "go", "mod", "download"
    # Not using std_cargo_fetch_args as cbindgen needs all targets
    system "cargo", "fetch", "--locked", "--manifest-path", "baml/engine/language_client_cffi/Cargo.toml"
  end

  def install
    ENV["BAML_LIBRARY_DISABLE_DOWNLOAD"] = "true"
    ENV["BAML_LIBRARY_PATH"] = libexec/shared_library("libbaml_cffi")
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["PROTOC_GEN_GO_PATH"] = formula_opt_bin("protoc-gen-go")/"protoc-gen-go"

    system "cargo", "build", "--lib", "--release", "--manifest-path", "baml/engine/language_client_cffi/Cargo.toml",
           *std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    libexec.install shared_library("baml/engine/target/release/libbaml_cffi")

    ldflags = %W[
      -X github.com/clidey/whodb/cli/pkg/version.Version=#{version}
      -X github.com/clidey/whodb/cli/pkg/version.Commit=#{tap.user}
      -X github.com/clidey/whodb/cli/pkg/version.BuildDate=#{time.iso8601}
      -X github.com/clidey/whodb/cli/internal/baml.BAMLVersion=#{baml_version}
    ]

    system "go", "build", *std_go_args(output: libexec/"whodb", ldflags:), "./cli"
    (bin/"whodb").write_env_script libexec/"whodb", BAML_LIBRARY_PATH: ENV["BAML_LIBRARY_PATH"]
    bin.install_symlink bin/"whodb" => "whodb-cli"

    generate_completions_from_executable(bin/"whodb", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/whodb version")

    output = shell_output("#{bin}/whodb connections list --format json")
    assert_kind_of Array, JSON.parse(output)
  end
end
