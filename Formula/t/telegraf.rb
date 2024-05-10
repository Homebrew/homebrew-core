class Telegraf < Formula
  desc "Plugin-driven server agent for collecting & reporting metrics"
  homepage "https://www.influxdata.com/time-series-platform/telegraf/"
  url "https://github.com/influxdata/telegraf/archive/refs/tags/v1.30.2.tar.gz"
  sha256 "3514d870fe1899f20c5d1f1545233413cbe11061b23a0cafbd44b861a9295dc6"
  license "MIT"
  head "https://github.com/influxdata/telegraf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b800a3ab1316663b34625a0b1f7459f4649d6d6667612c2ca151942b48588b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32120347e9269c52b98ce41869ebc1a96a1218807f5101cc32d452cd3d496cab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c81195c90a46379ea9435ba493a33193441af0480431b6cb198956937548620"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee658c10fa0d41a66bc84af79069afb38c65bd944cffddfc4c35846b8154e3d6"
    sha256 cellar: :any_skip_relocation, ventura:        "ba74227d358371cf522878e6f7c139ddc10b4441611aa950f0b218066471fbf8"
    sha256 cellar: :any_skip_relocation, monterey:       "d15d0affd9579ff7a9d596df67866e19635307a2252ec5c9ec94124df7a8f9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bfc73ac50b28caf31b5cecbb7bebc89ff9bbef735c83df1280f79b61afe1756"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/influxdata/telegraf/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/telegraf"
    (etc/"telegraf.conf").write Utils.safe_popen_read("#{bin}/telegraf", "config")
  end

  def post_install
    # Create directory for additional user configurations
    (etc/"telegraf.d").mkpath
  end

  service do
    run [opt_bin/"telegraf", "-config", etc/"telegraf.conf", "-config-directory", etc/"telegraf.d"]
    keep_alive true
    working_dir var
    log_path var/"log/telegraf.log"
    error_log_path var/"log/telegraf.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/telegraf --version")
    (testpath/"config.toml").write shell_output("#{bin}/telegraf -sample-config")
    system "#{bin}/telegraf", "-config", testpath/"config.toml", "-test",
           "-input-filter", "cpu:mem"
  end
end
