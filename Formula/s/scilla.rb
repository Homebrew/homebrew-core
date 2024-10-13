class Scilla < Formula
  desc "DNS, subdomain, port, directory enumeration tool"
  homepage "https://github.com/edoardottt/scilla"
  url "https://github.com/edoardottt/scilla/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "3a8c3d0b1e061b517b887bd3718810ea09998fbd474a50c769fe244767c67a32"
  license "GPL-3.0-or-later"
  head "https://github.com/edoardottt/scilla.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7bd5cee872a247fee98b2f8d6e21a80c07850ad09fcd00e2bbd182bfbaf3ab75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2f4345eabc7c4c52af7d4bafa9c8763bcc3bc7165cdcab01fb9183d676e32a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc86278a8751678280b191ce61732c9edd7953face82a5323da368253ea66cbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e813e5c031fb8890a8e76d323dae827548bdc4d2314514220332bddc488f2069"
    sha256 cellar: :any_skip_relocation, sonoma:         "b376bbf11e24d81a67370de1fe80ba7e07f95e68a5dec636b38cae77d345a436"
    sha256 cellar: :any_skip_relocation, ventura:        "b056341afbd1c454373e5f5e35621e2f98d1f517957f9a0fe260d692186c8104"
    sha256 cellar: :any_skip_relocation, monterey:       "94f86d582fecf9236a68682a252ecee74a20448093937a38b3d899da4201bc2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6213d7a324c144a73dcbc4e9c824992bf983c7b89e408fc5f1c50afd203157a4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/scilla"
  end

  test do
    output = shell_output("#{bin}/scilla dns -target brew.sh")
    assert_match "[+]FOUND brew.sh IN CNAME: brew.sh.", output
  end
end
