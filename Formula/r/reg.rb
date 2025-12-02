class Reg < Formula
  desc "Docker registry v2 command-line client"
  homepage "https://r.j3ss.co"
  url "https://github.com/genuinetools/reg/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "b65787bff71bff21f21adc933799e70aa9b868d19b1e64f8fd24ebdc19058430"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "84e42284b946dc3f88d65243680eeb75761c66ad88125bcfd0f95545c42371d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3467572641a49a95d3337e16c68fe76dd65377026f02478d955512679303cf42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb3907d256779b4df3e1c499bc389b56135e9cb22f7414bad350f74a0ff90a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c6f6d7cef992aec32bb6742dd36c85c0ad46fc3b2d47450e31f983964725681"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf9938a3488e5e4ceb2534f2a032c4d9427787a92e6550f90eea0ff70cdb77da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bf430c32dbb66c850bf8c6acbe2fc2953a8ada29e12c0e7b474317fe537fffb"
    sha256 cellar: :any_skip_relocation, sonoma:         "0baa7f427b863fba20abfeb72d188c8b4052e6e218f37d231263b2fbee648327"
    sha256 cellar: :any_skip_relocation, ventura:        "702ff0454b5ab6cb3dc19c8fc2a18587a510a93a81069b8701bffdbcf25e350f"
    sha256 cellar: :any_skip_relocation, monterey:       "9dad4aea34600bf11782f4c4e9867439369a4b59e1eae7ad05a7640fe39c1917"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca9db7f72804b3701ea833c24802b5c81f4297d556482596cc755f67a1061dbb"
    sha256 cellar: :any_skip_relocation, catalina:       "566141035e7c94c92a4422addea68ea86431916055d14bfe5e20de79c3a6451c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "293883fc2cf4c4380eac853819e833eeac21f8d184814aca4c0cb53d8ca80a57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1f1396a2eec2571aed2861955e94d41c841e2e57d85202084f263e95ecb1ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "buster", shell_output("#{bin}/reg tags debian")
  end
end
