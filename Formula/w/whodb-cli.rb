class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  license "Apache-2.0"

  stable do
    url "https://github.com/clidey/whodb/archive/refs/tags/0.139.0.tar.gz"
    sha256 "ae7dbf583abe552caf83b1e535f3a3b753d9fdc062a537c76fe69864b86cf186"

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
    sha256 cellar: :any, arm64_golden_gate: "4e8ffb6940e4967f97a4861fac7650fae1c1aad58faf6806ca60c205d99e8342"
    sha256 cellar: :any, arm64_tahoe:       "6318d3a3f41867b0c98631ac21c8193f70bc5c0167adf78e66e33a5c0412ee39"
    sha256 cellar: :any, arm64_sequoia:     "24168db3b776a5ea739185e86483fbfdc6f89dfcb25f8f27878586fb2f576544"
    sha256 cellar: :any, arm64_linux:       "fc69cd0d1301bce4d491dca216023c8de48cb45b8b0f951aae5dd4bf0704766f"
    sha256 cellar: :any, x86_64_linux:      "df80b9715e5587a9a07c7c2410d6eec3b1f35003cfc62402d662c2cac68221a9"
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
