class Shellharden < Formula
  desc "Bash syntax highlighter that encourages/fixes variables quoting"
  homepage "https://github.com/anordal/shellharden"
  url "https://github.com/anordal/shellharden/archive/refs/tags/v4.3.1.tar.gz"
  sha256 "3c16a98502df01a2fa2b81467d5232cc1aa4c80427e2ecf9f7e74591d692e22c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "10e48028dfbd67212a7e171016423b63d885db6e8db6ada26930768b695e73fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "35779a784fd4b700c9adbfa9749a3fd7f9c8a6a41c58c05ce66e6eaf6b0b6961"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d622dcbef74e1646b456d8c6c0d67244b8c402ef0546684257b768556f5d4ba4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91e03fe42cd8587d1bc955d26921cc08da0f954a84209c98157fba3bc08028e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47253968d98051492b6323daeac35981df7ebe4ab1f604b8261c2e3847dc415d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a338286ab8c93d9cd4e4aec92a8212d6110cf23cd5a017587fa4bf62cbf9bbad"
    sha256 cellar: :any_skip_relocation, ventura:        "ec1ad4ad2ac6ad351e1bd9713838959b8346c9c3d07efb70cd3de002d5ddbb44"
    sha256 cellar: :any_skip_relocation, monterey:       "e33b74610ecaae0df74599a3ef689fa89ede02befc72a7f655c68b95ed540c7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c204c007a8f608b5f7d08262be092318bd371d444c72f60a6f9772ebbc762cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e728c3f307c0729bb68b56c7e6f9abfee8a4192b830b554974effeecf0bda41f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"script.sh").write <<~SH
      dog="poodle"
      echo $dog
    SH
    system bin/"shellharden", "--replace", "script.sh"
    assert_match "echo \"$dog\"", (testpath/"script.sh").read
  end
end
