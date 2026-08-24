class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "f364a4306be8dc9bddaa01274fc05c44b8d0dec3f03daf2c1f30d56a20752913"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ad4ee2a8f9a9b023f9044bb44b3f7fffad87b5ddb44aa89bbebb216238b7af6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20862bc43a3ec6ca2dba3e32fb5fcc7571d684a1648b200e67d7ca7cba87d68a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d503ac0d6f8cc8328f611d830856529fc766509c064f84bfc218c04bfc71fe58"
    sha256 cellar: :any_skip_relocation, sonoma:        "53e312005864832d995b14bae3c2a4a273a7365e3d359c532bd0892330273021"
    sha256 cellar: :any,                 arm64_linux:   "beb0cb2b01f38b2ac05e8a02ee3428e8aa5fae22b93cbb22168e72f255b31cf1"
    sha256 cellar: :any,                 x86_64_linux:  "04081a7adbee0eadbaa1ac1164e79a1f1211089e3e1ba5725160166746a67ef7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rabbitmqadmin", "shell", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rabbitmqadmin --help")
    assert_match "Configuration file '~/.rabbitmqadmin.conf' does not exist",
                 shell_output("#{bin}/rabbitmqadmin config_file show 2>&1", 65)
    assert_match "error sending request for url (http://localhost:15672/api/channels)",
                 shell_output("#{bin}/rabbitmqadmin list channels 2>&1", 65)
  end
end
