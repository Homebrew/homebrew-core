class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.17.0.tgz"
  sha256 "00792c7668da5fc711e79cce1ee130e3e4adf5696a622b995f7b2a4127a4dc7f"
  license "MPL-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4439edefa94f5a68416fe607c2348093afb67d8e3ff93fbacfe37c150513525d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ebb4e410777f4fd73d5b2d9e053f6406cd7f35df730e884e73414e7980316b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "335c7ce7476abb0b30ec27480b0eb18e60d11771ee0bed1baa90ecfe79949d0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5d51a665b609e9e1a536e91ffc13930f695cc96265b2905e15804760f4cf8e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04be8789f7840d7b88ef1402e3ed3e686e5c5e115bbaa90b46633b47ba4750bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d149dcabb4fe72ca676257c3f21cd6d04cdb03fae0fc279e2ad2cb430dc916e"
    sha256 cellar: :any_skip_relocation, ventura:        "1cfc86cf1a4166d848d6e6dcc2c8a64ed89a2cbc8f15f2136b6396c7877b8cd1"
    sha256 cellar: :any_skip_relocation, monterey:       "61eda1b0dc67fa27004de110b8ec47d4d0702bfa5f0b7d4499155a897f62d513"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d05854619c01c03c774facc77e0b54bf7dbc083236343688def51272cc225812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46eee957ebc27472822c184984ab5534641818668b31408a135d5709f7295789"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
    generate_completions_from_executable(bin/"triton", "completion", shells: [:bash])
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match(/\ANAME  CURR  ACCOUNT  USER  URL$/, output)
  end
end
