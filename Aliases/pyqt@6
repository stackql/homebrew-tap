class Pyqt < Formula
  desc "Python bindings for v6 of Qt"
  homepage "https://www.riverbankcomputing.com/software/pyqt/intro"
  url "https://files.pythonhosted.org/packages/8a/a6/12565a8b14faaeb3ecf3edb5bc1e6bcb622dab776c23ea4eb4c369176c75/PyQt6-6.4.1.tar.gz"
  sha256 "0c1dcadf161331cfdbde0906c05f7f8048dc4907d717647c33bbc4404146f59f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c9e3c37a5f361d768a69cf923a1f20c955b005ad299147da8f7f7d0f31e193e"
    sha256 cellar: :any,                 arm64_monterey: "9a7c8743c21eaf2220763ec9c61698699c6722b7c6752f3732d6c0123bbd6130"
    sha256 cellar: :any,                 arm64_big_sur:  "c9aa4dd849e88694d54039e7fc513132f948e479007935b764ad128d95ff8f21"
    sha256 cellar: :any,                 ventura:        "d96775aadf921dbb3f814bd6ad3bb3ed81e4c2c564b03a3a9ab05142a72e286f"
    sha256 cellar: :any,                 monterey:       "717d86b002c94342954b0a2ca6624cab3c891f64f35f48c7e0ae97f5f06ef711"
    sha256 cellar: :any,                 big_sur:        "29ab892885801dd08af61311932a6cfeb3def0a702ba563e8cbf605231bc8743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59db3caed790afefbcf4d78ce5b8e58e21f68e369695157b7dd43c4e8c468ac1"
  end

  depends_on "pyqt-builder" => :build
  depends_on "sip"          => :build

  depends_on "python@3.11"
  depends_on "qt"

  fails_with gcc: "5"

  # extra components
  resource "PyQt6-3D" do
    url "https://files.pythonhosted.org/packages/6a/f7/55aa01d56d4c6c20374389fc400822eb9327298111ab891f20af3e786037/PyQt6_3D-6.4.0.tar.gz"
    sha256 "c5e8e2224b9d461fe21158040b4446b5fd82ae563c76a8943292abd887a02df1"
  end

  resource "PyQt6-Charts" do
    url "https://files.pythonhosted.org/packages/b3/b4/fb94c482644f4a0a8bbb4f785eeea46c1229adc4468fcc025194482011e7/PyQt6_Charts-6.4.0.tar.gz"
    sha256 "b46eb12840516a039c36f70bb3f8423337f98fde266b582cead4049b77b43f64"
  end

  resource "PyQt6-DataVisualization" do
    url "https://files.pythonhosted.org/packages/62/b1/cee46d028500e171e98b8893fcbd2671601044db3eeb911e360e04546d98/PyQt6_DataVisualization-6.4.0.tar.gz"
    sha256 "1f276ddb1e774859356a977aeb8196866e280b03d3e33c7760a1f188153ce0a8"
  end

  resource "PyQt6-NetworkAuth" do
    url "https://files.pythonhosted.org/packages/a0/1c/6042587ed1e934206f7a2498e73b18ed7fc598c717af0561c409eaa01bfd/PyQt6_NetworkAuth-6.4.0.tar.gz"
    sha256 "c16ec80232d88024b60d04386a23cc93067e5644a65f47f26ffb13d84dcd4a6d"
  end

  resource "PyQt6-sip" do
    url "https://files.pythonhosted.org/packages/1e/24/99d1f9938afd58cf2d6120454cb36214bd76e18443b130b80b09fb368579/PyQt6_sip-13.4.1.tar.gz"
    sha256 "e00e287ea05bbc293fc6e2198301962af9b7b622bd2daf4288f925a88ae35dc9"
  end

  resource "PyQt6-WebEngine" do
    url "https://files.pythonhosted.org/packages/c1/54/80bebc08c537723a145442c3997bab122ebc8e540ae807f4291b2ce7f8bb/PyQt6_WebEngine-6.4.0.tar.gz"
    sha256 "4c71c130860abcd11e04cafb22e33983fa9a3aee8323c51909b15a1701828e21"
  end

  def python3
    "python3.11"
  end

  def install
    # HACK: there is no option to set the plugindir
    inreplace "project.py", "builder.qt_configuration['QT_INSTALL_PLUGINS']", "'#{share}/qt/plugins'"

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      --target-dir #{site_packages}
      --scripts-dir #{bin}
      --confirm-license
    ]
    system "sip-install", *args

    resource("PyQt6-sip").stage do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end

    resources.each do |r|
      next if r.name == "PyQt6-sip"
      # Don't build WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
      next if r.name == "PyQt6-WebEngine" && OS.mac? && DevelopmentTools.clang_build_version <= 1200

      r.stage do
        inreplace "pyproject.toml", "[tool.sip.project]",
          "[tool.sip.project]\nsip-include-dirs = [\"#{site_packages}/PyQt#{version.major}/bindings\"]\n"
        system "sip-install", "--target-dir", site_packages
      end
    end
  end

  test do
    system bin/"pyuic#{version.major}", "-V"
    system bin/"pylupdate#{version.major}", "-V"

    system python3, "-c", "import PyQt#{version.major}"
    pyqt_modules = %w[
      3DAnimation
      3DCore
      3DExtras
      3DInput
      3DLogic
      3DRender
      Gui
      Multimedia
      Network
      NetworkAuth
      Positioning
      Quick
      Svg
      Widgets
      Xml
    ]
    # Don't test WebEngineCore bindings on macOS if the SDK is too old to have built qtwebengine in qt.
    pyqt_modules << "WebEngineCore" if OS.linux? || DevelopmentTools.clang_build_version > 1200
    pyqt_modules.each { |mod| system python3, "-c", "import PyQt#{version.major}.Qt#{mod}" }
  end
end
