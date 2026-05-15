class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "7132526c2e0e20c6169161ea85d4863d99b4534d00d4ec3b56c2e07940a2cd67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6115a82c30ac8f8577957fc635b6f39c09fe6c6644146ed654b361e36777a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e104d2c3ebc4de7e9c8e2d709bce59000deb2ec97033520a774d2b93c196b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f38d90a66b1f6e90500e7cca258d791e20b373031ec8d5647bf0c8dde32640d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cc6d8d46f94498a73477371e34b53408c71e092c7fca55153d1fd8d57ddbec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e92c9af120133eac591b302278396de6af2b0eddbb5cde950ba868add712d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad610a02774314b7f61741d9aceab16a3464474ad3affedb6e4d91c336b3c1fd"
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
