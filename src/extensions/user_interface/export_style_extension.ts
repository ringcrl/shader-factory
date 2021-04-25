import { WebviewExtension } from '../webview_extension';

export class ExportStyleExtension implements WebviewExtension {
  public generateContent(): string {
    return `
      #export-glsl {
        position: absolute;
        top: 1%;
        left: 52%;
        color: #fff;
        padding: 3px 5px;
        background: #000;
        border-radius: 5px;
        z-index: 1;
      }
    `;
  }
}
