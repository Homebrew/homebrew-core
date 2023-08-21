class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v1.2.0/tt-1.2.0-complete.tar.gz"
  sha256 "a10e90404eb47dba6050e88c76f389b67b68e0ece9302234060d4d867f3b5dc9"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "997fde7ea1d491150fab45aa08f35ac378abf8e2f6112a66db09b302b0407b31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad8ce717c76705e081b5948f5800c57606be62bb17b2762f950124ae06374ca6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ec424fc3458847404647e97746c1bd7b95eb0d0a145f64e529efc223f0f5b14"
    sha256                               ventura:        "4cd4e4697ab5abd237a696887526831b3e0d4a4747fd853ce552cfdc9956bff7"
    sha256                               monterey:       "f7a392b21958de48e84132c58842ca6d9bc9cf1addf0484229d379c09fde1d28"
    sha256                               big_sur:        "7781344735fd60625dec1e88bfc6455ee7fed48b4c806c5aa8410da3a5c066d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dded03427a01e695b75873c8d2eaac445abe2462739b7c2417172aae96dfd08"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on "bash-completion"
  end

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
