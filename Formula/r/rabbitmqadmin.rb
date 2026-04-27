class Rabbitmqadmin < Formula
  desc "Command-line tool for RabbitMQ that uses the HTTP API"
  homepage "https://www.rabbitmq.com/docs/management-cli"
  url "https://github.com/rabbitmq/rabbitmqadmin-ng/archive/refs/tags/v2.29.0.tar.gz"
  sha256 "e36196a8ce3c8a68da601c408e214465dd17d5240b3781710c49e7b7e348d1ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cef7e9a67a4f56ff6a11e86c1f64e7ae0981c466d0d13568b6daf897e14ab5f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed88ebc55bd84114682a63a3e4e3076280f1561b52f1a88bbe8f99a5447dea27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d908e32dbadedcb01fe7ff61e255ed8d0c20569ac0d41a8580b16c978118f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b75c1042d0c83447f353f091d0dc04179e5c5c83bd9a4702c2d73d44e7f8733a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfa91258845ca19ae6135d18c0dc05dca05b92650c63298efc092d657e16c4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08b9e6c525eaeab9a767a4220a3b8a46edea225d1651fbd950d24f838388107"
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
