class Remarshal < Formula
  include Language::Python::Virtualenv

  desc "Convert between TOML, YAML and JSON"
  homepage "https://github.com/dbohdan/remarshal"
  url "https://github.com/dbohdan/remarshal/archive/v0.8.0.tar.gz"
  sha256 "ab2ab978aaf20e97719680f8f242ea3407090b562d747205486a02cdbf14d17f"
  head "https://github.com/dbohdan/remarshal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "301ed86d51a55376e300dd4e854e96fe2d8c699f1973c03ce27183f4e5dfd7b4" => :mojave
    sha256 "63e760f882da33ef11b3b0d1339d75aa8876f2ce73b7e895edd7f00e2c3c453c" => :high_sierra
    sha256 "6bdde286613dec8bdbecf6a9f1c5726109e94eed5a77ecf603cc07184faa352b" => :sierra
    sha256 "ed9cf2d1329e174021492b470f34e3f953fb06148758255607e5acb54d52cd75" => :el_capitan
  end

  depends_on "python@2"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "pytoml" do
    url "https://files.pythonhosted.org/packages/6d/2a/c5a0eb781cff59df8613a531f07f9d82bb47ea595aa91c6f114f1621a94a/pytoml-0.1.14.tar.gz"
    sha256 "aff69147d436c3ba8c7f3bc1b3f4aa3d7e47d305a495f2631872e6429694aabf"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/c5/39/4da7c2dbc4f023fba5fb2325febcadf0d0ce0efdc8bd12083a0f65d20653/python-dateutil-2.7.2.tar.gz"
    sha256 "9d8074be4c993fbe4947878ce593052f71dac82932a677d49194d8ce9778002e"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources

    ["toml", "yaml", "json"].permutation(2).each do |informat, outformat|
      bin.install_symlink "remarshal" => "#{informat}2#{outformat}"
    end
  end

  test do
    json = <<~EOS.chomp
      {"foo.bar":"baz","qux":1}
    EOS
    yaml = <<~EOS.chomp
      foo.bar: baz
      qux: 1

    EOS
    toml = <<~EOS.chomp
      "foo.bar" = "baz"
      qux = 1

    EOS
    assert_equal yaml, pipe_output("#{bin}/remarshal -if=json -of=yaml", json)
    assert_equal yaml, pipe_output("#{bin}/json2yaml", json)
    assert_equal toml, pipe_output("#{bin}/remarshal -if=yaml -of=toml", yaml)
    assert_equal toml, pipe_output("#{bin}/yaml2toml", yaml)
    assert_equal json, pipe_output("#{bin}/remarshal -if=toml -of=json", toml).chomp
    assert_equal json, pipe_output("#{bin}/toml2json", toml).chomp
  end
end
