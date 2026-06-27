class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "6236cf711256cc20b26a0ec2f3f48d33b4d0ee920e456d93fe801f3447db2f93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0d81e39830e95b4f0f43693d00563a1127e109a824d6060c7d0e1e3863fe3d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbd471eaf51453642f4639639b69ef98bb6a566cc2fcb893ecb7f5068277b2b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91671657a72c8e7210f8e4c8d7ad2d56938f65f6a45674104239ba7305b90f9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d105925e3b22cd5c5f607036e63df65114d979628ee8a80b72492ad6c2db261"
    sha256 cellar: :any,                 arm64_linux:   "2ad403cd1d9e72bc3e6ab40e8a153d5bd54905ef6433adc2da95766b2948624f"
    sha256 cellar: :any,                 x86_64_linux:  "f1445bae6751912c2a8b1945df94992425e7cc0e3c7025de59fc5d9d87cb1a6d"
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
