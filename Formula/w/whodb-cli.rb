class WhodbCli < Formula
  desc "Database management CLI with TUI interface, MCP server support, AI, and more"
  homepage "https://whodb.com/"
  license "Apache-2.0"

  stable do
    url "https://github.com/clidey/whodb/archive/refs/tags/0.138.0.tar.gz"
    sha256 "971c7cb1ab555c8a76bf8a7fb28fae5f675982d89f0b6b76523941961edba493"

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
    sha256 cellar: :any, arm64_golden_gate: "391b1431488b4603896e2bfb71124402a7191c0f925aba09a2290dddeb7fe591"
    sha256 cellar: :any, arm64_tahoe:       "091481c8f2ed8bbb44a3173251d01c37d1bf6610b568990a7ac60c43de02fe5a"
    sha256 cellar: :any, arm64_sequoia:     "e6c02f8e9f03e1fe4c75c2362aa2d450dfce82f4e843f7e8d838e56d82844632"
    sha256 cellar: :any, arm64_linux:       "2fffb7a01144cf2a2163d0874f7227cce01bb6fe0c8151b730ea1b8f86ebfe49"
    sha256 cellar: :any, x86_64_linux:      "0d929438f083cf84e3bf03a6f06a10811dda8881ba4bd10e63ca798e8d3f68d2"
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
