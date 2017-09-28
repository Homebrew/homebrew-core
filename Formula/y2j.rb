class Y2j < Formula
  include Language::Python::Virtualenv
  desc "command-line tool for converting between YAML and JSON and vice versa."
  homepage "https://github.com/wildducktheories/y2j"
  url "https://github.com/wildducktheories/y2j/archive/v1.1.1.tar.gz"
  sha256 "e11ac6886937b3c9784f61d3c77d00d9b4dbf3fa10ec6ddc6f847b68196d9f5d"
  head "https://github.com/wildducktheories/y2j.git"

  depends_on "jq" => :run
  depends_on "base64" => :run
  depends_on :python => :run
  depends_on "docker" => :optional

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  def install
    py_version = Language::Python.major_minor_version "python"
    venv_site_packages_path = libexec/"lib/python#{py_version}/site-packages"
    ENV["PYTHONPATH"] = venv_site_packages_path
    venv = virtualenv_create(libexec, "python")

    venv.pip_install resources

    # Force our venv python for use with y2j
    inreplace buildpath/"y2j.sh", /^#!.*bash/,
                               "#!/usr/bin/env bash\nexport PYTHONPATH=#{venv_site_packages_path}:$PYTHONPATH"

    install_script = `./y2j.sh installer #{prefix.to_s}`

    (buildpath/"install_y2j.sh").write install_script

    chmod 0755, "./install_y2j.sh"
    system "./install_y2j.sh"

    bin.install "y2j.sh", "y2j", "j2y", "yq"
  end

  test do
    yaml_test_input = <<-EOS.undent
      ---
      foo: bar
    EOS

    expected_output = "{\n    \"foo\": \"bar\"\n}"

    assert_equal expected_output, pipe_output("#{bin}/y2j", yaml_test_input)
  end
end
