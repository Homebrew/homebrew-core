class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "b52d5964ef296cf6a356522626a622225a825ab1248844172ace0058e211f988"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0db28ef58afe590f9ad48c68386563384ae663ba096f8357cb40b45fec28efda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42f321988b091870c9da9a0ed505f75a4c2b77a025b7253924152b706cb2f3dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3d621a09729b24ea5d90ac73ec765a627224379ba24dd2bf27e71707c2b98ac9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "2df83e7a50f1440247bb510ed64eaf02615a68de97b8c66af991c5a8aaa090ee"
    sha256 cellar: :any,                 arm64_linux:       "145202cd8d3ef4774bbe04c08553a4f9564b962a6c71a4ea0dd9c0c7f2c9fb48"
    sha256 cellar: :any,                 x86_64_linux:      "b7e6baa7dd2759aabd65fb7e7c443a3cf69b791368f6c4377d2e2500930f9904"
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
