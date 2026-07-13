class Mosek < Formula
  desc "Mosek optimization software"
  homepage "https://www.mosek.com/"
  url "https://download.mosek.com/stable/11.2.2/mosektoolsosxaarch64.tar.bz2"
  version "11.2.2"
  sha256 "8aa38b87eda3463088611072986874275187586204940e269fa276a466e31ac8"
  license ""
  depends_on "python@3.14" => :build

  def install
    # Extract and install mosek
    prefix.install Dir["*"]
    system Formula["python@3.14"].opt_bin/"python3",
      prefix/"11.2/tools/platform/osxaarch64/bin/install.py"

    # Link mosek bin directory to homebrew bin directory
    bin.install_symlink prefix/"11.2/tools/platform/osxaarch64/bin" => "mosek_bin"
    Dir["#{prefix}/11.2/tools/platform/osxaarch64/bin/*"].each do |file|
      next if File.directory?(file)
      bin.install_symlink file => File.basename(file)
    end

    # Link header files to homebrew include directory
    Dir["#{prefix}/11.2/tools/platform/osxaarch64/h/*.h"].each do |header|
      include.install_symlink header => File.basename(header)
    end

    system bin/"mosek", "-v"
  end

  def caveats
    <<~EOS
      This installation uses the Apple Silicon ARM platform identifier: osxaarch64.

      A Mosek license is required. Request one at:
      https://www.mosek.com/products/mosek/

      Place the license file at:
      $HOME/mosek/mosek.lic
    EOS
  end

  test do
    system "#{bin}/mosek", "-v"
  end
end
