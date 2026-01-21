class Six < Formula
  desc "Python 2 and 3 compatibility utilities"
  homepage "https://github.com/benjaminp/six"
  url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
  sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7985c480809b773f5c7b28d3eac082ad3bcc69c04e2ac100810901b0a6e410b"
  end

  disable! date: "2025-10-16", because: "does not meet homebrew/core's requirements for Python library formulae"

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).select { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  def caveats
    python_versions = pythons.map { |p| p.version.major_minor }
                             .map(&:to_s)
                             .join(", ")

    <<~EOS
      This formula provides the `six` module for Python #{python_versions}.
      If you need `six` for a different version of Python, use pip.
    EOS
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~PYTHON
        import six
        assert not six.PY2
        assert six.PY3
      PYTHON
    end
  end
end
